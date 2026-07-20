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

public import ISO_9945_Kernel_Poll
public import POSIX_Kernel_Clock

// MARK: - POSIX Poll policy
//
// Wave 3.5-8 (2026-05-02) — Item 4 sub-cycle 8 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.Poll.poll typed form.
// `poll(2)` IS very EINTR-prone per POSIX spec — apply canonical EINTR
// retry via `error.code.isInterrupted` (Error_Primitives.Error has
// `.code` accessor — same canonical pattern as Wave 3.5-1 IO.Read /
// Wave 3.5-5 Process.Wait).
//
// iso-9945 throws `Error_Primitives.Error` directly (no domain Error
// type at iso-9945 Kernel.Poll); canonical pattern works.

extension POSIX.Kernel {
    /// Poll operations with EINTR retry policy.
    public enum Poll: Sendable {}
}

// MARK: - Wave 3.5-Final-8 (2026-05-02) — value-type typealiases for nested types

extension POSIX.Kernel.Poll {
    /// Poll events bitmask (OptionSet struct) — typealias to canonical
    /// iso-9945 home.
    public typealias Events = ISO_9945.Kernel.Poll.Events

    /// Poll entry (descriptor + event mask + returned events) — typealias
    /// to canonical iso-9945 home.
    public typealias Entry = ISO_9945.Kernel.Poll.Entry
}

extension POSIX.Kernel.Poll {
    /// Waits for events on a set of file descriptors, automatically
    /// retrying on EINTR.
    ///
    /// Policy-aware wrapper around
    /// ``ISO_9945/Kernel/Poll/poll(_:timeout:)``.
    /// `poll(2)` is very EINTR-prone (signal interruption common).
    ///
    /// - Parameters:
    ///   - entries: Array of poll entries to monitor. On return, each entry's
    ///     `returned` field reflects the events that occurred.
    ///   - timeout: Maximum time to wait in milliseconds.
    ///     - `-1`: Block indefinitely.
    ///     - `0`: Return immediately (non-blocking poll).
    ///     - `> 0`: Wait up to this many milliseconds. The timeout is a
    ///       deadline: EINTR retries resume with the remaining time on the
    ///       continuous (monotonic) clock, and the call returns 0 if the
    ///       deadline elapses during a retry. Callers that want the raw
    ///       restart-on-EINTR syscall behavior should use the L2 form
    ///       ``ISO_9945/Kernel/Poll/poll(_:timeout:)`` directly.
    /// - Returns: The number of entries with events, or 0 on timeout.
    /// - Throws: `Error_Primitives.Error` on failure (excluding EINTR).
    @inlinable
    public static func poll(
        _ entries: inout [ISO_9945.Kernel.Poll.Entry],
        timeout: Int32
    ) throws(Error_Primitives.Error) -> Int {
        // Non-positive timeouts carry no deadline: -1 blocks indefinitely,
        // 0 returns immediately. Plain EINTR retry is correct for both.
        guard timeout > 0 else {
            while true {
                do throws(Error_Primitives.Error) {
                    return try ISO_9945.Kernel.Poll.poll(&entries, timeout: timeout)
                } catch  where error.code.isInterrupted {
                    continue  // Retry on EINTR
                }
            }
        }

        // Bounded wait: track the deadline on the continuous (monotonic)
        // clock so EINTR retries consume the original budget instead of
        // restarting the full timeout (fable-448 F-001).
        let start = Clock.Continuous.now
        var remaining = timeout
        while true {
            do throws(Error_Primitives.Error) {
                return try ISO_9945.Kernel.Poll.poll(&entries, timeout: remaining)
            } catch  where error.code.isInterrupted {
                let elapsedMilliseconds =
                    (Clock.Continuous.now.nanoseconds - start.nanoseconds) / 1_000_000
                guard elapsedMilliseconds < UInt64(timeout) else {
                    return 0  // Deadline elapsed during EINTR retry: timeout.
                }
                remaining = timeout - Int32(elapsedMilliseconds)
            }
        }
    }
}
