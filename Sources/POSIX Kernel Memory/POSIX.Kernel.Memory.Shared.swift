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

// MARK: - POSIX Memory.Shared policy
//
// Wave 3.5-4 (2026-05-01) — Item 4 sub-cycle 4 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Memory.Shared typed Phase 1.5
// forms. `shm_open(3)` / `shm_unlink(3)` are NOT EINTR-prone per POSIX spec
// — pure pass-through for namespace symmetry.
//
// **Pre-Wave-3.5 era cleanup (Wave 3.5-4)**: the prior pre-Phase-1.5
// `extension Memory.Shared { open(name:access:options:permissions:) }` at
// this file was a redundant duplicate of iso-9945's typed Phase 1.5 form
// `Memory.Shared.open(...)` (identical signature; identical behavior). It
// has been DELETED — swift-memory's `Memory.Shared.open(...)` call sites
// resolve to iso-9945's typed form post-deletion (functional parity).

extension POSIX.Kernel.Memory {
    /// POSIX shared memory (shm_open/shm_unlink) operations.
    public enum Shared: Sendable {}
}

// MARK: - Wave 3.5-Final-4 (2026-05-02) — value-type typealiases for nested types

extension POSIX.Kernel.Memory.Shared {
    /// Shared error type — typealias to canonical L1 home.
    public typealias Error = Memory.Shared.Error

    /// Shared access mode — typealias to canonical iso-9945 home.
    public typealias Access = Memory.Shared.Access

    /// Shared options (creation flags) — typealias to canonical iso-9945 home.
    public typealias Options = Memory.Shared.Options
}

extension POSIX.Kernel.Memory.Shared {
    /// Opens or creates a POSIX shared memory object, returning a typed descriptor.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Memory/Shared/open(name:access:options:permissions:)``.
    ///
    /// - Parameters:
    ///   - name: The name of the shared memory object (must start with '/').
    ///   - access: Read/write access mode.
    ///   - options: Creation options (create, exclusive, truncate).
    ///   - permissions: Permission mode for creation.
    /// - Returns: A typed descriptor for the shared memory object.
    /// - Throws: ``Memory/Shared/Error`` on failure.
    @unsafe
    @inlinable
    public static func open(
        name: UnsafePointer<CChar>,
        access: Memory.Shared.Access,
        options: Memory.Shared.Options = [],
        permissions: ISO_9945.Kernel.File.Permissions = .ownerReadWrite
    ) throws(Memory.Shared.Error) -> ISO_9945.Kernel.Descriptor {
        try unsafe Memory.Shared.open(
            name: name,
            access: access,
            options: options,
            permissions: permissions
        )
    }

    /// Removes a POSIX shared memory object.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Memory/Shared/unlink(name:)``.
    ///
    /// - Parameter name: The name of the shared memory object to remove.
    /// - Throws: ``Memory/Shared/Error`` on failure.
    @unsafe
    @inlinable
    public static func unlink(name: UnsafePointer<CChar>) throws(Memory.Shared.Error) {
        try unsafe Memory.Shared.unlink(name: name)
    }
}
