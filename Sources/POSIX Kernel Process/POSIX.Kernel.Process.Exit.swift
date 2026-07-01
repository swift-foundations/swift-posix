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

// MARK: - POSIX Process.Exit policy
//
// Wave 3.5-5 (2026-05-01) — Item 4 sub-cycle 5 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.Process.Exit.now typed form.
// `_exit(2)` is NOT EINTR-prone (it terminates the process) — pure
// pass-through for namespace symmetry. Non-throwing, `Never` return.

extension POSIX.Kernel.Process {
    /// Process exit operations.
    public enum Exit: Sendable {}
}

extension POSIX.Kernel.Process.Exit {
    /// Terminates the process immediately, bypassing atexit handlers and
    /// stdio buffer flushing.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Process/Exit/now(_:)``. Uses `_exit(2)` directly.
    ///
    /// - Parameter status: The exit status (0 typically indicates success).
    /// - Returns: Never returns; the process is terminated.
    @inlinable
    public static func now(_ status: Int32) -> Never {
        ISO_9945.Kernel.Process.Exit.now(status)
    }
}
