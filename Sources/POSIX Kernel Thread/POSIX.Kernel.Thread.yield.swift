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

// MARK: - POSIX Thread.yield policy
//
// Wave 3.5-7 (2026-05-01) — Item 4 sub-cycle 7 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.Thread.yield static form.
// `sched_yield(2)` is NOT EINTR-prone per POSIX spec — pure pass-through
// for namespace symmetry. Non-throwing.

extension POSIX.Kernel.Thread {
    /// Yields execution to the OS scheduler as a hint.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Thread/yield()``.
    ///
    /// Policy-free; the OS scheduler may or may not honor the yield hint.
    @inlinable
    public static func yield() {
        ISO_9945.Kernel.Thread.yield()
    }
}
