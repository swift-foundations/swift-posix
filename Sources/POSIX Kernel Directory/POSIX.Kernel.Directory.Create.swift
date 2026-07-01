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

public import ISO_9945_Kernel_Directory

// MARK: - POSIX Directory.Create policy
//
// Wave 3.5-3 (2026-05-01) — Item 4 sub-cycle 3 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Directory.Create typed forms.
// Modernized from pre-Phase-1.5 raw-mkdirat composition. `mkdir(2)` /
// `mkdirat(2)` are NOT EINTR-prone per POSIX spec — pure pass-through
// for namespace symmetry, enabling Wave 3.5-Final L3-unifier redirect.
//
// Argument labels match iso-9945 typed Phase 1.5 form
// (`(_ path: , relativeTo descriptor: , permissions:)`); the prior
// asymmetric `(relativeTo: , path: , permissions:)` shape is replaced
// to enable clean atomic flip at Wave 3.5-Final.

extension POSIX.Kernel.Directory {
    /// Directory creation operations.
    public enum Create: Sendable {}
}

// MARK: - Wave 3.5-Final-3 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.Directory.Create {
    /// Create error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.Directory.Create.Error
}

extension POSIX.Kernel.Directory.Create {
    /// Creates a directory using `Path`.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Directory/Create/create(_:permissions:)``.
    ///
    /// - Parameters:
    ///   - path: The path to create.
    ///   - permissions: The permissions for the new directory (default 0o755).
    /// - Throws: ``ISO_9945/Kernel/Directory/Create/Error`` on failure.
    @inlinable
    public static func create(
        _ path: borrowing Path.Borrowed,
        permissions: ISO_9945.Kernel.File.Permissions = ISO_9945.Kernel.File.Permissions(rawValue: 0o755)
    ) throws(ISO_9945.Kernel.Directory.Create.Error) {
        try ISO_9945.Kernel.Directory.Create.create(path, permissions: permissions)
    }

    /// Creates a directory relative to a descriptor, using `Path`.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Directory/Create/create(_:relativeTo:permissions:)``.
    ///
    /// - Parameters:
    ///   - path: The path of the directory to create.
    ///   - descriptor: The directory descriptor that `path` is interpreted
    ///     relative to.
    ///   - permissions: The permissions for the new directory (default 0o755).
    /// - Throws: ``ISO_9945/Kernel/Directory/Create/Error`` on failure.
    @inlinable
    public static func create(
        _ path: borrowing Path.Borrowed,
        relativeTo descriptor: borrowing ISO_9945.Kernel.Descriptor,
        permissions: ISO_9945.Kernel.File.Permissions = ISO_9945.Kernel.File.Permissions(rawValue: 0o755)
    ) throws(ISO_9945.Kernel.Directory.Create.Error) {
        try ISO_9945.Kernel.Directory.Create.create(path, relativeTo: descriptor, permissions: permissions)
    }
}
