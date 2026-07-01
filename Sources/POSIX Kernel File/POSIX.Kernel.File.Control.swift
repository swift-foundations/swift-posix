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

// MARK: - POSIX File.Control policy
//
// Wave 3.5-2 (2026-05-01) — Item 4 sub-cycle 2 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.File.Control typed forms.
// `fcntl(2)` with F_GETFL/F_SETFL (the only Control ops in scope —
// setBlocking/setNonBlocking) is NOT EINTR-prone per POSIX spec.
// fcntl with F_SETLKW (file-locking) IS EINTR-prone but Lock has its
// own POSIX.Kernel.Lock at Wave 3.5-1; Control here is non-Lock fcntl.

extension POSIX.Kernel.File {
    /// File descriptor control operations (fcntl-based).
    public enum Control {}
}

// MARK: - Wave 3.5-Final-1 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.File.Control {
    /// Control error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.File.Control.Error
}

extension POSIX.Kernel.File.Control {
    /// Sets a file descriptor to non-blocking I/O mode.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/File/Control/setNonBlocking(_:)``.
    ///
    /// - Parameter descriptor: The file descriptor.
    /// - Throws: ``ISO_9945/Kernel/File/Control/Error`` if fcntl fails.
    @inlinable
    public static func setNonBlocking(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor
    ) throws(ISO_9945.Kernel.File.Control.Error) {
        try ISO_9945.Kernel.File.Control.setNonBlocking(descriptor)
    }

    /// Sets a file descriptor to blocking I/O mode.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/File/Control/setBlocking(_:)``.
    ///
    /// - Parameter descriptor: The file descriptor.
    /// - Throws: ``ISO_9945/Kernel/File/Control/Error`` if fcntl fails.
    @inlinable
    public static func setBlocking(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor
    ) throws(ISO_9945.Kernel.File.Control.Error) {
        try ISO_9945.Kernel.File.Control.setBlocking(descriptor)
    }
}
