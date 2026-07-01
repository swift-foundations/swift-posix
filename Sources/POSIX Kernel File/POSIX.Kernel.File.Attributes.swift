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

public import ISO_9945_Kernel_File

// MARK: - POSIX File.Attributes policy
//
// Wave 3.5-1 (2026-05-01) — Item 4 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.File.Attributes typed forms.
// `chmod(2)` / `fchmod(2)` are NOT EINTR-prone per POSIX spec — these
// wrappers are pure pass-through for namespace symmetry.

extension POSIX.Kernel.File {
    /// POSIX file attribute operations (permissions).
    public enum Attributes {}
}

// MARK: - Wave 3.5-Final-1 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.File.Attributes {
    /// Attributes error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.File.Attributes.Error
}

extension POSIX.Kernel.File.Attributes {
    /// Changes the permissions of a file via path.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/File/Attributes/set(_:at:)``.
    ///
    /// - Parameters:
    ///   - permissions: The new permissions.
    ///   - path: The path to the file.
    /// - Throws: ``ISO_9945/Kernel/File/Attributes/Error`` on failure.
    @inlinable
    public static func set(
        _ permissions: ISO_9945.Kernel.File.Permissions,
        at path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.File.Attributes.Error) {
        try ISO_9945.Kernel.File.Attributes.set(permissions, at: path)
    }

    /// Changes the permissions of an open file descriptor.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/File/Attributes/set(_:on:)``.
    ///
    /// - Parameters:
    ///   - permissions: The new permissions.
    ///   - descriptor: The file descriptor.
    /// - Throws: ``ISO_9945/Kernel/File/Attributes/Error`` on failure.
    @inlinable
    public static func set(
        _ permissions: ISO_9945.Kernel.File.Permissions,
        on descriptor: borrowing ISO_9945.Kernel.Descriptor
    ) throws(ISO_9945.Kernel.File.Attributes.Error) {
        try ISO_9945.Kernel.File.Attributes.set(permissions, on: descriptor)
    }
}
