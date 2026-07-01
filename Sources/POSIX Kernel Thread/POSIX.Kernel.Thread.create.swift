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

public import ISO_9945_Kernel_Thread

// MARK: - POSIX Thread.create policy
//
// Wave 3.5-7 (2026-05-01) — Item 4 sub-cycle 7 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.Thread.create static form.
// `pthread_create(3)` is NOT EINTR-prone per POSIX spec — pure
// pass-through for namespace symmetry.

extension POSIX.Kernel.Thread {
    /// Creates a new OS thread.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Thread/create(_:)``.
    ///
    /// The closure is invoked exactly once on the spawned OS thread.
    ///
    /// - Parameter body: The work to run on the new thread.
    /// - Returns: A handle to the created thread (~Copyable).
    /// - Throws: ``ISO_9945/Kernel/Thread/Error`` on failure.
    @inlinable
    public static func create(
        _ body: @escaping @Sendable () -> Void
    ) throws(ISO_9945.Kernel.Thread.Error) -> ISO_9945.Kernel.Thread.Handle {
        try ISO_9945.Kernel.Thread.create(body)
    }
}
