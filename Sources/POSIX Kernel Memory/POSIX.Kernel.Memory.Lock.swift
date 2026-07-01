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

public import ISO_9945_Kernel_Memory

// MARK: - POSIX Memory.Lock policy
//
// Wave 3.5-4 (2026-05-01) — Item 4 sub-cycle 4 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Memory.Lock typed Phase 1.5 forms.
// `mlock(2)` / `munlock(2)` / `mlockall(2)` / `munlockall(2)` are NOT
// EINTR-prone per POSIX spec — pure pass-through for namespace symmetry.
//
// Distinct from POSIX.Kernel.Lock (file-locking via fcntl F_SETLK) at
// Wave 3.5-1. Memory.Lock is for memory residency (mlock/munlock).
//
// Memory.Lock.All.lockAll(flags: Int32) raw form at iso-9945 is NOT wrapped
// per ground rule #9 — only the typed Phase 1.5 form
// `lockAll(_ flags: All.Options)` is the wrapping target.

extension POSIX.Kernel.Memory {
    /// Memory locking operations (mlock/munlock family).
    public enum Lock: Sendable {}
}

// MARK: - Wave 3.5-Final-4 (2026-05-02) — value-type typealiases for nested types

extension POSIX.Kernel.Memory.Lock {
    /// Lock error type — typealias to canonical L1 home.
    public typealias Error = Memory.Lock.Error

    /// Lock.All sub-namespace (mlockall/munlockall) — typealias to canonical
    /// home (extension on L1 Memory.Lock at iso-9945).
    public typealias All = Memory.Lock.All
}

extension POSIX.Kernel.Memory.Lock {
    /// Locks a memory region into physical RAM.
    ///
    /// Pass-through wrapper around iso-9945's `@unsafe` mlock variant.
    /// Prevents the pages from being paged to swap. Uses `mlock(2)`.
    ///
    /// - Parameters:
    ///   - address: The base address of the region.
    ///   - length: The number of bytes to lock.
    /// - Throws: ``Memory/Lock/Error`` on failure.
    ///
    /// ## Platform Notes
    ///
    /// ### macOS
    /// Requires `com.apple.developer.kernel.memory-allocation` entitlement.
    ///
    /// ### Linux
    /// Subject to `RLIMIT_MEMLOCK` resource limit.
    @unsafe
    @inlinable
    public static func lock(
        address: UnsafeRawPointer,
        length: Memory.Address.Count
    ) throws(Memory.Lock.Error) {
        try unsafe Memory.Lock.lock(address: address, length: length)
    }

    /// Unlocks a memory region, allowing paging.
    ///
    /// Pass-through wrapper around iso-9945's `@unsafe` munlock variant.
    /// Allows the pages to be paged to swap. Uses `munlock(2)`.
    ///
    /// - Parameters:
    ///   - address: The base address of the region.
    ///   - length: The number of bytes to unlock.
    /// - Throws: ``Memory/Lock/Error`` on failure.
    @unsafe
    @inlinable
    public static func unlock(
        address: UnsafeRawPointer,
        length: Memory.Address.Count
    ) throws(Memory.Lock.Error) {
        try unsafe Memory.Lock.unlock(address: address, length: length)
    }

    /// Locks all current and/or future pages using typed flags.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Memory/Lock/lockAll(_:)`` (typed Phase 1.5 form).
    /// Uses `mlockall(2)`.
    ///
    /// - Parameter flags: Typed flags for mlockall.
    /// - Throws: ``Memory/Lock/Error`` on failure.
    @inlinable
    public static func lockAll(_ flags: Memory.Lock.All.Options) throws(Memory.Lock.Error) {
        try Memory.Lock.lockAll(flags)
    }

    /// Unlocks all locked pages.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Memory/Lock/unlockAll()``.
    /// Uses `munlockall(2)`.
    ///
    /// - Throws: ``Memory/Lock/Error`` on failure.
    @inlinable
    public static func unlockAll() throws(Memory.Lock.Error) {
        try Memory.Lock.unlockAll()
    }
}
