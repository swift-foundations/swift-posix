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

public import ISO_9945_Kernel_Process

// MARK: - POSIX Process.Kill policy
//
// Wave 3.5-5 (2026-05-01) — Item 4 sub-cycle 5 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.Process.Kill.kill typed form.
// `kill(2)` is NOT EINTR-prone per POSIX spec (signal delivery is
// non-blocking) — pure pass-through for namespace symmetry.

extension POSIX.Kernel.Process {
    /// Process signal-delivery operations.
    public enum Kill: Sendable {}
}

extension POSIX.Kernel.Process.Kill {
    /// Sends a signal to a process.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Process/Kill/kill(_:_:)``.
    ///
    /// - Parameters:
    ///   - process: The target process ID.
    ///   - signal: The signal to send.
    /// - Throws: ``ISO_9945/Kernel/Process/Error`` on failure.
    @inlinable
    public static func kill(
        _ process: ISO_9945.Kernel.Process.ID,
        _ signal: ISO_9945.Kernel.Signal.Number
    ) throws(ISO_9945.Kernel.Process.Error) {
        try ISO_9945.Kernel.Process.Kill.kill(process, signal)
    }
}
