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

// MARK: - POSIX File.Times policy
//
// Wave 3.5-1 (2026-05-01) — Item 4 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.File.Times typed forms.
// `utimensat(2)` / `futimens(2)` are NOT EINTR-prone per POSIX spec —
// these wrappers are pure pass-through for namespace symmetry.

extension POSIX.Kernel.File {
    /// File timestamp operations.
    public enum Times {}
}

// MARK: - Wave 3.5-Final-1 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.File.Times {
    /// Times error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.File.Times.Error
}

extension POSIX.Kernel.File.Times {
    /// Sets the access and modification times of a file via path.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/File/Times/set(access:modification:at:followSymlinks:)``.
    ///
    /// - Parameters:
    ///   - accessTime: The new access time.
    ///   - modificationTime: The new modification time.
    ///   - path: The path to the file.
    ///   - followSymlinks: If false, operates on the symlink itself (default: true).
    /// - Throws: ``ISO_9945/Kernel/File/Times/Error`` on failure.
    @inlinable
    public static func set(
        access accessTime: ISO_9945.Kernel.Time,
        modification modificationTime: ISO_9945.Kernel.Time,
        at path: borrowing Path.Borrowed,
        followSymlinks: Bool = true
    ) throws(ISO_9945.Kernel.File.Times.Error) {
        try ISO_9945.Kernel.File.Times.set(
            access: accessTime,
            modification: modificationTime,
            at: path,
            followSymlinks: followSymlinks
        )
    }

    /// Sets the access and modification times of an open file descriptor.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/File/Times/set(access:modification:on:)``.
    ///
    /// - Parameters:
    ///   - accessTime: The new access time.
    ///   - modificationTime: The new modification time.
    ///   - descriptor: The file descriptor.
    /// - Throws: ``ISO_9945/Kernel/File/Times/Error`` on failure.
    @inlinable
    public static func set(
        access accessTime: ISO_9945.Kernel.Time,
        modification modificationTime: ISO_9945.Kernel.Time,
        on descriptor: borrowing ISO_9945.Kernel.Descriptor
    ) throws(ISO_9945.Kernel.File.Times.Error) {
        try ISO_9945.Kernel.File.Times.set(
            access: accessTime,
            modification: modificationTime,
            on: descriptor
        )
    }
}
