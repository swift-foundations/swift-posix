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

// MARK: - EINTR-Safe Write Operations

/// POSIX I/O write operations with automatic EINTR retry.
///
/// These are policy-aware wrappers around the raw POSIX syscalls in `ISO_9945.Kernel.IO.Write`.
/// They automatically retry on EINTR (signal interruption), which is the expected behavior
/// for most applications.
///
/// ## When to Use
///
/// Use these wrappers when you want the standard "retry on EINTR" behavior.
/// Use the raw `ISO_9945.Kernel.IO.Write` functions when you need to handle
/// EINTR explicitly (e.g., for interruptible I/O with signal handling).
///
/// ## Example
///
/// ```swift
/// // Policy-aware (retries on EINTR):
/// let n = try POSIX.Kernel.IO.Write.write(fd, from: buffer)
///
/// // Raw syscall (can throw on EINTR):
/// let n = try ISO_9945.Kernel.IO.Write.write(fd, from: buffer)
/// ```
extension POSIX.Kernel {
    /// I/O write operations namespace.
    public enum IO {
        /// Write operations with EINTR retry policy.
        public enum Write {}
    }
}

// MARK: - Wave 3.5-Final-1 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.IO.Write {
    /// Write error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.IO.Write.Error
}

extension POSIX.Kernel.IO.Write {
    /// Writes bytes to a file descriptor, automatically retrying on EINTR.
    ///
    /// This is the policy-aware wrapper that handles signal interruption automatically.
    /// For raw syscall behavior, use `ISO_9945.Kernel.IO.Write.write()`.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor to write to.
    ///   - buffer: The buffer to write from.
    /// - Returns: Number of bytes written (may be less than `buffer.count`).
    /// - Throws: ``Kernel/IO/Write/Error`` on failure (excluding EINTR).
    @inlinable
    public static func write(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from buffer: UnsafeRawBufferPointer
    ) throws(ISO_9945.Kernel.IO.Write.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.IO.Write.Error) {
                return unsafe try ISO_9945.Kernel.IO.Write.write(descriptor, from: buffer)
            } catch  where error.code.isInterrupted {
                continue  // Retry on EINTR
            }
        }
    }

    /// Writes bytes to a file descriptor at a specific offset, automatically retrying on EINTR.
    ///
    /// This is the policy-aware wrapper that handles signal interruption automatically.
    /// For raw syscall behavior, use `ISO_9945.Kernel.IO.Write.pwrite()`.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor to write to.
    ///   - buffer: The buffer to write from.
    ///   - offset: The file offset to write at.
    /// - Returns: Number of bytes written (may be less than `buffer.count`).
    /// - Throws: ``Kernel/IO/Write/Error`` on failure (excluding EINTR).
    @inlinable
    public static func pwrite(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from buffer: UnsafeRawBufferPointer,
        at offset: ISO_9945.Kernel.File.Offset
    ) throws(ISO_9945.Kernel.IO.Write.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.IO.Write.Error) {
                return unsafe try ISO_9945.Kernel.IO.Write.pwrite(descriptor, from: buffer, at: offset)
            } catch  where error.code.isInterrupted {
                continue  // Retry on EINTR
            }
        }
    }

    /// Writes all bytes to a file descriptor, handling partial writes and EINTR.
    ///
    /// This function loops until all bytes are written or a non-retriable error occurs.
    /// It handles both partial writes (which are normal) and EINTR (signal interruption).
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor to write to.
    ///   - buffer: The buffer to write from.
    /// - Throws: ``Kernel/IO/Write/Error`` on failure.
    @inlinable
    public static func writeAll(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from buffer: UnsafeRawBufferPointer
    ) throws(ISO_9945.Kernel.IO.Write.Error) {
        guard let baseAddress = buffer.baseAddress else {
            return
        }

        var written = 0
        let total = buffer.count

        while written < total {
            let remaining = unsafe UnsafeRawBufferPointer(
                start: baseAddress.advanced(by: written),
                count: total - written
            )
            let n = unsafe try write(descriptor, from: remaining)
            if n == 0 {
                // Should not happen for regular files, but handle gracefully
                throw .platform(Error_Primitives.Error(code: .POSIX.EIO))
            }
            written += n
        }
    }
}

// MARK: - Span Adapters

extension POSIX.Kernel.IO.Write {
    /// Writes bytes from a span to a file descriptor, automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor to write to.
    ///   - span: The span containing bytes to write.
    /// - Returns: Number of bytes written.
    /// - Throws: `ISO_9945.Kernel.IO.Write.Error` on failure.
    @inlinable
    public static func write(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from span: Swift.Span<Byte>
    ) throws(ISO_9945.Kernel.IO.Write.Error) -> Int {
        unsafe try span.withUnsafeBytes { buffer throws(ISO_9945.Kernel.IO.Write.Error) in
            unsafe try write(descriptor, from: buffer)
        }
    }

    /// Writes bytes from a span to a file descriptor at a specific offset, automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor to write to.
    ///   - span: The span containing bytes to write.
    ///   - offset: The file offset to write at.
    /// - Returns: Number of bytes written.
    /// - Throws: `ISO_9945.Kernel.IO.Write.Error` on failure.
    @inlinable
    public static func pwrite(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from span: Swift.Span<Byte>,
        at offset: ISO_9945.Kernel.File.Offset
    ) throws(ISO_9945.Kernel.IO.Write.Error) -> Int {
        unsafe try span.withUnsafeBytes { buffer throws(ISO_9945.Kernel.IO.Write.Error) in
            unsafe try pwrite(descriptor, from: buffer, at: offset)
        }
    }

    /// Writes all bytes from a span to a file descriptor, automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor to write to.
    ///   - span: The span containing bytes to write.
    /// - Throws: `ISO_9945.Kernel.IO.Write.Error` on failure.
    @inlinable
    public static func writeAll(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from span: Swift.Span<Byte>
    ) throws(ISO_9945.Kernel.IO.Write.Error) {
        unsafe try span.withUnsafeBytes { buffer throws(ISO_9945.Kernel.IO.Write.Error) in
            unsafe try writeAll(descriptor, from: buffer)
        }
    }
}
