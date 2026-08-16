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

// MARK: - POSIX Signal.Mask policy
//
// Wave 3.5-6 (2026-05-01) — Item 4 sub-cycle 6 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Signal.Mask typed forms.
// `pthread_sigmask(3)` / `sigpending(2)` are NOT EINTR-prone per POSIX
// spec — pure pass-through for namespace symmetry.
//
// iso-9945 uses `pthread_sigmask` (thread-safe per-thread mask),
// not `sigprocmask` (process-wide; problematic in multithreaded programs).

extension POSIX.Kernel.Signal {
    /// Signal mask operations (per-thread blocked-signal set).
    public enum Mask: Sendable {}
}

// MARK: - Wave 3.5-Final-6 (2026-05-02) — value-type typealias for Mask.How

extension POSIX.Kernel.Signal.Mask {
    /// Mask change mode (block/unblock/set — struct RawRepresentable) —
    /// typealias to canonical iso-9945 home.
    public typealias How = ISO_9945.Kernel.Signal.Mask.How
}

extension POSIX.Kernel.Signal.Mask {
    /// Changes the calling thread's signal mask, returning the previous mask.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Signal/Mask/change(_:signals:)``.
    ///
    /// - Parameters:
    ///   - how: How to change the mask (block, unblock, set).
    ///   - signals: The set of signals to apply.
    /// - Returns: The previous signal mask.
    /// - Throws: ``ISO_9945/Kernel/Signal/Error`` on failure.
    @inlinable
    public static func change(
        _ how: ISO_9945.Kernel.Signal.Mask.How,
        signals: ISO_9945.Kernel.Signal.Set
    ) throws(ISO_9945.Kernel.Signal.Error) -> ISO_9945.Kernel.Signal.Set {
        try ISO_9945.Kernel.Signal.Mask.change(how, signals: signals)
    }

    /// Returns the set of pending signals (blocked but raised).
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Signal/Mask/pending()``.
    ///
    /// A signal is pending if it has been raised but is currently blocked
    /// by the thread's signal mask.
    ///
    /// - Returns: The set of pending signals.
    /// - Throws: ``ISO_9945/Kernel/Signal/Error`` on failure.
    @inlinable
    public static func pending() throws(ISO_9945.Kernel.Signal.Error) -> ISO_9945.Kernel.Signal.Set
    {
        try ISO_9945.Kernel.Signal.Mask.pending()
    }
}
