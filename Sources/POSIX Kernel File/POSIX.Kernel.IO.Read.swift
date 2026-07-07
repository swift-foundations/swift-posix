// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-posix open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-posix project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import ISO_9945_Kernel_File

// MARK: - EINTR-Safe Read Operations

/// POSIX I/O read operations with automatic EINTR retry.
///
/// These are policy-aware wrappers around the raw POSIX syscalls in `ISO_9945.Kernel.IO.Read`.
/// They automatically retry on EINTR (signal interruption), which is the expected behavior
/// for most applications.
///
/// ## When to Use
///
/// Use these wrappers when you want the standard "retry on EINTR" behavior.
/// Use the raw `ISO_9945.Kernel.IO.Read` functions when you need to handle
/// EINTR explicitly, such as for interruptible I/O with signal handling.
///
/// ## Example
///
/// ```swift
/// // Policy-aware (retries on EINTR):
/// let n = try POSIX.Kernel.IO.Read.read(fd, into: buffer)
///
/// // Raw syscall (can throw on EINTR):
/// let n = try ISO_9945.Kernel.IO.Read.read(fd, into: buffer)
/// ```
extension POSIX.Kernel.IO {
    /// Read operations with EINTR retry policy.
    public enum Read {}
}

// MARK: - Wave 3.5-Final-1 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.IO.Read {
    /// Read error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.IO.Read.Error
}

extension POSIX.Kernel.IO.Read {
    /// Reads bytes from a file descriptor, automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor to read from.
    ///   - buffer: The buffer to read into.
    /// - Returns: Number of bytes read. Returns 0 on EOF.
    /// - Throws: ``Kernel/IO/Read/Error`` on failure (excluding EINTR).
    @inlinable
    public static func read(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        into buffer: UnsafeMutableRawBufferPointer
    ) throws(ISO_9945.Kernel.IO.Read.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.IO.Read.Error) {
                return unsafe try ISO_9945.Kernel.IO.Read.read(descriptor, into: buffer)
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    /// Reads bytes from a file descriptor at a specific offset, automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor to read from.
    ///   - buffer: The buffer to read into.
    ///   - offset: The file offset to read from.
    /// - Returns: Number of bytes read. Returns 0 on EOF.
    /// - Throws: ``Kernel/IO/Read/Error`` on failure (excluding EINTR).
    @inlinable
    public static func pread(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        into buffer: UnsafeMutableRawBufferPointer,
        at offset: ISO_9945.Kernel.File.Offset
    ) throws(ISO_9945.Kernel.IO.Read.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.IO.Read.Error) {
                return unsafe try ISO_9945.Kernel.IO.Read.pread(descriptor, into: buffer, at: offset)
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    /// Reads all bytes from a file descriptor until EOF, handling partial reads and EINTR.
    ///
    /// This function loops until EOF (read returns 0) or a non-retriable error occurs.
    /// It handles both partial reads (which are normal) and EINTR (signal interruption).
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor to read from.
    ///   - buffer: The buffer to read into.
    /// - Returns: Total number of bytes read.
    /// - Throws: ``Kernel/IO/Read/Error`` on failure.
    @inlinable
    public static func readAll(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        into buffer: UnsafeMutableRawBufferPointer
    ) throws(ISO_9945.Kernel.IO.Read.Error) -> Int {
        guard let baseAddress = buffer.baseAddress else {
            return 0
        }

        var totalRead = 0
        let total = buffer.count

        while totalRead < total {
            let remaining = unsafe UnsafeMutableRawBufferPointer(
                start: baseAddress.advanced(by: totalRead),
                count: total - totalRead
            )
            let n = unsafe try read(descriptor, into: remaining)
            if n == 0 {
                break  // EOF
            }
            totalRead += n
        }
        return totalRead
    }
}

// MARK: - Span Adapters

extension POSIX.Kernel.IO.Read {
    /// Reads bytes from a file descriptor into a mutable span, automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor to read from.
    ///   - span: The mutable span to read into.
    /// - Returns: Number of bytes read. Returns 0 on EOF.
    /// - Throws: `ISO_9945.Kernel.IO.Read.Error` on failure.
    @inlinable
    public static func read(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        into span: inout MutableSpan<Byte>
    ) throws(ISO_9945.Kernel.IO.Read.Error) -> Int {
        try unsafe span.withUnsafeMutableBytes { (buffer: UnsafeMutableRawBufferPointer) throws(ISO_9945.Kernel.IO.Read.Error) -> Int in
            unsafe try read(descriptor, into: buffer)
        }
    }

    /// Reads bytes from a file descriptor at a specific offset into a mutable span, automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor to read from.
    ///   - span: The mutable span to read into.
    ///   - offset: The file offset to read from.
    /// - Returns: Number of bytes read. Returns 0 on EOF.
    /// - Throws: `ISO_9945.Kernel.IO.Read.Error` on failure.
    @inlinable
    public static func pread(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        into span: inout MutableSpan<Byte>,
        at offset: ISO_9945.Kernel.File.Offset
    ) throws(ISO_9945.Kernel.IO.Read.Error) -> Int {
        try unsafe span.withUnsafeMutableBytes { (buffer: UnsafeMutableRawBufferPointer) throws(ISO_9945.Kernel.IO.Read.Error) -> Int in
            unsafe try pread(descriptor, into: buffer, at: offset)
        }
    }
}
