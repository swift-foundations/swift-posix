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

public import ISO_9945_Kernel_Signal

// MARK: - POSIX Signal.Send policy
//
// Wave 3.5-6 (2026-05-01) — Item 4 sub-cycle 6 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Signal.Send typed forms.
// `kill(2)` / `raise(3)` / `kill(-pgid, ...)` are NOT EINTR-prone per
// POSIX spec — pure pass-through for namespace symmetry.
//
// **Cross-cycle coherence note**: Signal.Send.toProcess and
// POSIX.Kernel.Process.Kill.kill (Wave 3.5-5) both wrap `kill(2)` syscall
// with different argument orders + Error types. Signal-domain framing
// (sender's perspective, Signal.Error) vs Process-domain framing (target's
// perspective, Process.Error). Both legitimate; both wrapped at their
// respective domains per iso-9945's intentional dual-namespace shape.

extension POSIX.Kernel.Signal {
    /// Signal sending operations.
    public enum Send: Sendable {}
}

extension POSIX.Kernel.Signal.Send {
    /// Sends a signal to a process.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Signal/Send/toProcess(_:pid:)``.
    ///
    /// - Parameters:
    ///   - signal: The signal to send.
    ///   - pid: The target process ID.
    /// - Throws: ``ISO_9945/Kernel/Signal/Error`` on failure.
    @inlinable
    public static func toProcess(
        _ signal: ISO_9945.Kernel.Signal.Number,
        pid: ISO_9945.Kernel.Process.ID
    ) throws(ISO_9945.Kernel.Signal.Error) {
        try ISO_9945.Kernel.Signal.Send.toProcess(signal, pid: pid)
    }

    /// Sends a signal to the calling process.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Signal/Send/toSelf(_:)``.
    ///
    /// - Parameter signal: The signal to send.
    /// - Throws: ``ISO_9945/Kernel/Signal/Error`` on failure.
    @inlinable
    public static func toSelf(
        _ signal: ISO_9945.Kernel.Signal.Number
    ) throws(ISO_9945.Kernel.Signal.Error) {
        try ISO_9945.Kernel.Signal.Send.toSelf(signal)
    }

    /// Sends a signal to a process group.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Signal/Send/toGroup(_:pgid:)``.
    ///
    /// Uses `kill(-pgid, sig)` where the negative PID indicates a process
    /// group.
    ///
    /// - Parameters:
    ///   - signal: The signal to send.
    ///   - pgid: The target process group ID.
    /// - Throws: ``ISO_9945/Kernel/Signal/Error`` on failure.
    @inlinable
    public static func toGroup(
        _ signal: ISO_9945.Kernel.Signal.Number,
        pgid: ISO_9945.Kernel.Process.Group.ID
    ) throws(ISO_9945.Kernel.Signal.Error) {
        try ISO_9945.Kernel.Signal.Send.toGroup(signal, pgid: pgid)
    }
}
