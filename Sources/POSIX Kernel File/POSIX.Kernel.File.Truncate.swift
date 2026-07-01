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

// MARK: - POSIX File.Truncate policy
//
// Wave 3.5-1 (2026-05-01) — Item 4 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.File.Truncate typed forms.
// `ftruncate(2)` / `truncate(2)` can be EINTR-prone in rare cases (long
// filesystem operations interrupted by signal). Apply EINTR retry per
// POSIX.Kernel canonical pattern.

extension POSIX.Kernel.File {
    /// File truncation operations with EINTR retry policy.
    public enum Truncate {}
}

extension POSIX.Kernel.File.Truncate {
    /// Truncates a file to a specified length via file descriptor,
    /// automatically retrying on EINTR.
    ///
    /// Policy-aware wrapper around
    /// ``ISO_9945/Kernel/File/Truncate/truncate(_:to:)``.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor (must be open for writing).
    ///   - length: The new file size in bytes.
    /// - Throws: `Error_Primitives.Error` on failure (excluding EINTR).
    @inlinable
    public static func truncate(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        to length: ISO_9945.Kernel.File.Size
    ) throws(Error_Primitives.Error) {
        while true {
            do throws(Error_Primitives.Error) {
                try ISO_9945.Kernel.File.Truncate.truncate(descriptor, to: length)
                return
            } catch where error.code.isInterrupted {
                continue  // Retry on EINTR
            }
        }
    }

    /// Truncates a file to a specified length via path, automatically
    /// retrying on EINTR.
    ///
    /// Policy-aware wrapper around
    /// ``ISO_9945/Kernel/File/Truncate/truncate(path:to:)``.
    ///
    /// - Parameters:
    ///   - path: The file path (NUL-terminated CChar pointer).
    ///   - length: The new file size in bytes.
    /// - Throws: `Error_Primitives.Error` on failure (excluding EINTR).
    @inlinable
    public static func truncate(
        path: UnsafePointer<CChar>,
        to length: ISO_9945.Kernel.File.Size
    ) throws(Error_Primitives.Error) {
        while true {
            do throws(Error_Primitives.Error) {
                try unsafe ISO_9945.Kernel.File.Truncate.truncate(path: path, to: length)
                return
            } catch where error.code.isInterrupted {
                continue  // Retry on EINTR
            }
        }
    }
}
