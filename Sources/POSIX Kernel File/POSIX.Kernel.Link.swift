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

// MARK: - POSIX Link policy (hard links)
//
// Wave 3.5-2 (2026-05-01) — Item 4 sub-cycle 2 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.Link.create typed form.
// `link(2)` is NOT EINTR-prone per POSIX spec — pure pass-through for
// namespace symmetry.

extension POSIX.Kernel {
    /// Hard link operations.
    public enum Link {}
}

// MARK: - Wave 3.5-Final-2 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.Link {
    /// Link error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.Link.Error
}

extension POSIX.Kernel.Link {
    /// Creates a hard link.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/Link/create(at:to:)``.
    ///
    /// - Parameters:
    ///   - linkPath: The path where the hard link will be created.
    ///   - existingPath: The path to the existing file.
    /// - Throws: ``ISO_9945/Kernel/Link/Error`` on failure.
    @inlinable
    public static func create(
        at linkPath: borrowing Path.Borrowed,
        to existingPath: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.Link.Error) {
        try ISO_9945.Kernel.Link.create(at: linkPath, to: existingPath)
    }
}
