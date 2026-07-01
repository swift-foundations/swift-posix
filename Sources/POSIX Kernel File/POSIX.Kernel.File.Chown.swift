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

// MARK: - POSIX File.Chown policy
//
// Wave 3.5-2 (2026-05-01) — Item 4 sub-cycle 2 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.File.Chown typed forms.
// `chown(2)` / `lchown(2)` / `fchown(2)` are NOT EINTR-prone per POSIX
// spec — pure pass-through for namespace symmetry.

extension POSIX.Kernel.File {
    /// File ownership operations.
    public enum Chown {}
}

// MARK: - Wave 3.5-Final-1 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.File.Chown {
    /// Chown error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.File.Chown.Error
}

extension POSIX.Kernel.File.Chown {
    /// Changes the ownership of a file (follows symbolic links).
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/File/Chown/chown(path:uid:gid:)``.
    ///
    /// - Parameters:
    ///   - path: The path to the file.
    ///   - uid: The new user ID.
    ///   - gid: The new group ID.
    /// - Throws: ``ISO_9945/Kernel/File/Chown/Error`` on failure.
    @inlinable
    public static func chown(
        path: borrowing Path.Borrowed,
        uid: ISO_9945.Kernel.User.ID,
        gid: ISO_9945.Kernel.Group.ID
    ) throws(ISO_9945.Kernel.File.Chown.Error) {
        try ISO_9945.Kernel.File.Chown.chown(path: path, uid: uid, gid: gid)
    }

    /// Changes the ownership of a symbolic link (does not follow links).
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/File/Chown/lchown(path:uid:gid:)``.
    ///
    /// - Parameters:
    ///   - path: The path to the symbolic link.
    ///   - uid: The new user ID.
    ///   - gid: The new group ID.
    /// - Throws: ``ISO_9945/Kernel/File/Chown/Error`` on failure.
    @inlinable
    public static func lchown(
        path: borrowing Path.Borrowed,
        uid: ISO_9945.Kernel.User.ID,
        gid: ISO_9945.Kernel.Group.ID
    ) throws(ISO_9945.Kernel.File.Chown.Error) {
        try ISO_9945.Kernel.File.Chown.lchown(path: path, uid: uid, gid: gid)
    }

    /// Changes the ownership of an open file descriptor.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/File/Chown/fchown(_:uid:gid:)``.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor.
    ///   - uid: The new user ID.
    ///   - gid: The new group ID.
    /// - Throws: ``ISO_9945/Kernel/File/Chown/Error`` on failure.
    @inlinable
    public static func fchown(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        uid: ISO_9945.Kernel.User.ID,
        gid: ISO_9945.Kernel.Group.ID
    ) throws(ISO_9945.Kernel.File.Chown.Error) {
        try ISO_9945.Kernel.File.Chown.fchown(descriptor, uid: uid, gid: gid)
    }
}
