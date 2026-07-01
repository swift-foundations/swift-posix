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

// MARK: - POSIX File.Seek policy
//
// Wave 3.5-1 (2026-05-01) — Item 4 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.File.Seek typed forms.
// `lseek(2)` is NOT EINTR-prone per POSIX spec — these wrappers are
// pure pass-through for namespace symmetry, enabling Wave 3.5-Final
// redirect (`Kernel = POSIX.Kernel`).

extension POSIX.Kernel.File {
    /// File seek operations.
    public enum Seek {}
}

// MARK: - Wave 3.5-Final-1 (2026-05-02) — value-type typealiases for nested types

extension POSIX.Kernel.File.Seek {
    /// Seek error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.File.Seek.Error

    /// Seek whence (start/current/end) — typealias to canonical iso-9945
    /// home (struct at Seek.Whence; iso-9945 also has Seek.Origin enum).
    public typealias Whence = ISO_9945.Kernel.File.Seek.Whence
}

extension POSIX.Kernel.File.Seek {
    /// Repositions the file offset of a file descriptor.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/File/Seek/seek(_:offset:whence:)``.
    /// `lseek(2)` is not EINTR-prone per POSIX spec; this wrapper exists for
    /// namespace symmetry only.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor.
    ///   - offset: The offset value.
    ///   - whence: The reference point for the offset.
    /// - Returns: The resulting offset from the beginning of the file.
    /// - Throws: ``ISO_9945/Kernel/File/Seek/Error`` on failure.
    @discardableResult
    @inlinable
    public static func seek(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        offset: Int64,
        whence: ISO_9945.Kernel.File.Seek.Whence
    ) throws(ISO_9945.Kernel.File.Seek.Error) -> Int64 {
        try ISO_9945.Kernel.File.Seek.seek(descriptor, offset: offset, whence: whence)
    }

    /// Gets the current file offset.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/File/Seek/tell(_:)``.
    ///
    /// - Parameter descriptor: The file descriptor.
    /// - Returns: The current offset from the beginning of the file.
    /// - Throws: ``ISO_9945/Kernel/File/Seek/Error`` on failure.
    @inlinable
    public static func tell(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor
    ) throws(ISO_9945.Kernel.File.Seek.Error) -> Int64 {
        try ISO_9945.Kernel.File.Seek.tell(descriptor)
    }
}
