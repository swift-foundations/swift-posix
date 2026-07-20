// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-posix open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-posix project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

#if !os(Windows)

    import Testing

    @testable import POSIX_Kernel

    #if canImport(Darwin)
        import Darwin
    #elseif canImport(Glibc)
        import Glibc
    #endif

    extension POSIX.Kernel.Poll {
        enum Test {
            @Suite struct `Edge Case` {}
        }
    }

    // MARK: - Test Fixture

    /// No-op signal handler used to interrupt a blocked `poll(2)` with EINTR.
    private func pollTestSignalHandler(_: Int32) {}

    /// Installs a SIGUSR1 handler WITHOUT `SA_RESTART`, so a blocked
    /// `poll(2)` reliably fails with EINTR when signalled. Returns the
    /// previous disposition so the caller can restore it.
    private func installNonRestartingSIGUSR1Handler() -> sigaction {
        var previous = sigaction()
        var action = sigaction()
        #if canImport(Darwin)
            action.__sigaction_u.__sa_handler = pollTestSignalHandler
        #else
            action.__sigaction_handler = unsafeBitCast(
                pollTestSignalHandler as @convention(c) (Int32) -> Void,
                to: type(of: action.__sigaction_handler)
            )
        #endif
        action.sa_flags = 0
        sigemptyset(&action.sa_mask)
        sigaction(SIGUSR1, &action, &previous)
        return previous
    }

    /// Shared state for the dedicated poller thread.
    ///
    /// The test-runner thread keeps SIGUSR1 blocked (Swift Testing worker
    /// threads run with most signals masked), so the poll under test runs
    /// on its own pthread that explicitly unblocks SIGUSR1. Synchronization
    /// is by pthread_join happens-before; no concurrent access occurs.
    private final class PollRunContext: @unchecked Sendable {
        var entries: [POSIX.Kernel.Poll.Entry]
        var result: Int = -1
        var failed: Bool = false
        var elapsedMilliseconds: UInt64 = 0

        init(entries: [POSIX.Kernel.Poll.Entry]) {
            self.entries = entries
        }
    }

    /// Context handed to the interrupter thread: the pthread to signal.
    private final class PollInterrupterContext {
        let target: pthread_t
        init(target: pthread_t) { self.target = target }
    }

    /// Monotonic now, in nanoseconds, independent of the code under test.
    private func monotonicNowNanoseconds() -> UInt64 {
        #if canImport(Darwin)
            return clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW)
        #else
            var ts = timespec()
            clock_gettime(CLOCK_MONOTONIC, &ts)
            return UInt64(ts.tv_sec) * 1_000_000_000 + UInt64(ts.tv_nsec)
        #endif
    }

    /// Body of the dedicated poller thread: unblock SIGUSR1, then run the
    /// poll under test with a 250 ms timeout, recording result and elapsed
    /// wall time.
    private func pollThreadBody(_ context: PollRunContext) {
        var unblock = sigset_t()
        sigemptyset(&unblock)
        sigaddset(&unblock, SIGUSR1)
        pthread_sigmask(SIG_UNBLOCK, &unblock, nil)

        let start = monotonicNowNanoseconds()
        do {
            context.result = try POSIX.Kernel.Poll.poll(
                &context.entries,
                timeout: 250
            )
        } catch {
            context.failed = true
        }
        context.elapsedMilliseconds =
            (monotonicNowNanoseconds() - start) / 1_000_000
    }

    /// Body of the interrupter thread: SIGUSR1 at the poller every 50 ms,
    /// 12 times (600 ms of sustained interruption).
    private func interrupterThreadBody(_ context: PollInterrupterContext) {
        for _ in 0..<12 {
            usleep(50_000)  // 50 ms
            pthread_kill(context.target, SIGUSR1)
        }
    }

    // MARK: - Edge Case

    extension POSIX.Kernel.Poll.Test.`Edge Case` {

        /// Regression test for fable-448 F-001: the EINTR retry loop must
        /// honor the original deadline instead of restarting the full
        /// timeout on every interruption.
        ///
        /// A pipe that never becomes readable is polled with a 250 ms
        /// timeout while a sibling thread interrupts the poller with
        /// SIGUSR1 every 50 ms for 600 ms. Pre-fix, every EINTR restarts
        /// the full 250 ms window, so the call cannot return before the
        /// interruptions stop (~850 ms total). Post-fix, the call times
        /// out near the requested 250 ms.
        @Test
        func pollWithTimeoutReturnsNearDeadlineDespiteRepeatedEINTR() throws {
            let descriptors = try POSIX.Kernel.Pipe.pipe()

            let previousHandler = installNonRestartingSIGUSR1Handler()
            defer {
                var restore = previousHandler
                sigaction(SIGUSR1, &restore, nil)
            }

            let runContext = PollRunContext(
                entries: [
                    POSIX.Kernel.Poll.Entry(descriptors.read, requested: .input)
                ]
            )
            let runPointer = Unmanaged.passRetained(runContext).toOpaque()

            var poller: pthread_t?
            #if canImport(Darwin)
                pthread_create(
                    &poller, nil,
                    { raw in
                        pollThreadBody(
                            Unmanaged<PollRunContext>
                                .fromOpaque(raw).takeRetainedValue()
                        )
                        return nil
                    },
                    runPointer
                )
                let pollerThread = try #require(poller)
            #else
                var pollerThread = pthread_t()
                pthread_create(
                    &pollerThread, nil,
                    { raw in
                        pollThreadBody(
                            Unmanaged<PollRunContext>
                                .fromOpaque(raw!).takeRetainedValue()
                        )
                        return nil
                    },
                    runPointer
                )
                poller = pollerThread
            #endif

            let interrupterContext = PollInterrupterContext(target: pollerThread)
            let interrupterPointer =
                Unmanaged.passRetained(interrupterContext).toOpaque()

            var interrupter: pthread_t?
            #if canImport(Darwin)
                pthread_create(
                    &interrupter, nil,
                    { raw in
                        interrupterThreadBody(
                            Unmanaged<PollInterrupterContext>
                                .fromOpaque(raw).takeRetainedValue()
                        )
                        return nil
                    },
                    interrupterPointer
                )
            #else
                var interrupterHandle = pthread_t()
                pthread_create(
                    &interrupterHandle, nil,
                    { raw in
                        interrupterThreadBody(
                            Unmanaged<PollInterrupterContext>
                                .fromOpaque(raw!).takeRetainedValue()
                        )
                        return nil
                    },
                    interrupterPointer
                )
                interrupter = interrupterHandle
            #endif

            pthread_join(pollerThread, nil)
            if let interrupter {
                pthread_join(interrupter, nil)
            }

            #expect(runContext.failed == false)
            #expect(runContext.result == 0)
            // Pre-fix the full 250 ms window restarts on every EINTR, so
            // the call blocks until interruptions stop (~850 ms). Post-fix
            // it must return near the requested deadline. 600 ms leaves
            // generous slack for scheduler jitter under load.
            #expect(runContext.elapsedMilliseconds < 600)
        }
    }

#endif
