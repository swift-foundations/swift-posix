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

    private func pollTestSignalHandler(_: Int32) {}

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

    private final class PollRunContext: @unchecked Sendable {
        var entries: [POSIX.Kernel.Poll.Entry]
        var result: Int = -1
        var failed: Bool = false
        var elapsedMilliseconds: UInt64 = 0

        init(entries: [POSIX.Kernel.Poll.Entry]) {
            self.entries = entries
        }
    }

    private final class PollInterrupterContext {
        let target: pthread_t
        init(target: pthread_t) { self.target = target }
    }

    private func monotonicNowNanoseconds() -> UInt64 {
        #if canImport(Darwin)
            return clock_gettime_nsec_np(CLOCK_MONOTONIC_RAW)
        #else
            var ts = timespec()
            clock_gettime(CLOCK_MONOTONIC, &ts)
            return UInt64(ts.tv_sec) * 1_000_000_000 + UInt64(ts.tv_nsec)
        #endif
    }

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

    private func interrupterThreadBody(_ context: PollInterrupterContext) {
        for _ in 0..<12 {
            usleep(50_000)
            pthread_kill(context.target, SIGUSR1)
        }
    }

    extension POSIX.Kernel.Poll.Test.`Edge Case` {

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
                    &poller,
                    nil,
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
                    &pollerThread,
                    nil,
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
                    &interrupter,
                    nil,
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
                    &interrupterHandle,
                    nil,
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

            #expect(runContext.elapsedMilliseconds < 600)
        }
    }

#endif
