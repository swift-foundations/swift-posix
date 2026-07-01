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

// MARK: - POSIX File.Delete policy
//
// Wave 3.5-2 (2026-05-01) — Item 4 sub-cycle 2 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.File.Delete typed form.
// `unlink(2)` is NOT EINTR-prone per POSIX spec — pure pass-through
// for namespace symmetry, enabling Wave 3.5-Final redirect.

extension POSIX.Kernel.File {
    /// File deletion operations.
    public enum Delete {}
}

// MARK: - Wave 3.5-Final-1 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.File.Delete {
    /// Delete error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.File.Delete.Error
}

extension POSIX.Kernel.File.Delete {
    /// Removes a file or symbolic link.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/File/Delete/delete(_:)``.
    ///
    /// - Parameter path: The path to the file to remove.
    /// - Throws: ``ISO_9945/Kernel/File/Delete/Error`` on failure.
    @inlinable
    public static func delete(
        _ path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.File.Delete.Error) {
        try ISO_9945.Kernel.File.Delete.delete(path)
    }
}
