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

// MARK: - POSIX Process.Fork policy
//
// Wave 3.5-5 (2026-05-01) — Item 4 sub-cycle 5 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.Process.Fork.fork typed form.
// `fork(2)` is NOT EINTR-prone per POSIX spec — pure pass-through for
// namespace symmetry.

extension POSIX.Kernel.Process {
    /// Fork operations.
    public enum Fork: Sendable {}
}

// MARK: - Wave 3.5-Final-5 (2026-05-02) — value-type typealias for Fork.Result

extension POSIX.Kernel.Process.Fork {
    /// Fork result enum (.child / .parent(child:)) — typealias to canonical
    /// iso-9945 home.
    public typealias Result = ISO_9945.Kernel.Process.Fork.Result
}

extension POSIX.Kernel.Process.Fork {
    /// Creates a new process by duplicating the calling process.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Process/Fork/fork()``.
    ///
    /// - Returns: `.child` in the child process, `.parent(child:)` in the parent.
    /// - Throws: ``ISO_9945/Kernel/Process/Error`` on failure.
    ///
    /// ## Warning
    ///
    /// `fork()` is unsafe in multithreaded programs. Only async-signal-safe
    /// functions may be called between `fork()` and `exec()` in the child.
    @inlinable
    public static func fork() throws(ISO_9945.Kernel.Process.Error)
        -> ISO_9945.Kernel.Process.Fork.Result
    {
        try ISO_9945.Kernel.Process.Fork.fork()
    }
}
