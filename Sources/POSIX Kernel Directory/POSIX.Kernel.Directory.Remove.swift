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

public import ISO_9945_Kernel_Directory

// MARK: - POSIX Directory.Remove policy
//
// Wave 3.5-3 (2026-05-01) — Item 4 sub-cycle 3 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.Directory.Remove typed form.
// `rmdir(2)` is NOT EINTR-prone per POSIX spec — pure pass-through for
// namespace symmetry, enabling Wave 3.5-Final L3-unifier redirect.

extension POSIX.Kernel.Directory {
    /// Directory removal operations.
    public enum Remove: Sendable {}
}

// MARK: - Wave 3.5-Final-3 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.Directory.Remove {
    /// Remove error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.Directory.Remove.Error
}

extension POSIX.Kernel.Directory.Remove {
    /// Removes an empty directory using `Path`.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Directory/Remove/remove(_:)``.
    ///
    /// - Parameter path: The path to remove.
    /// - Throws: ``ISO_9945/Kernel/Directory/Remove/Error`` on failure.
    @inlinable
    public static func remove(
        _ path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.Directory.Remove.Error) {
        try ISO_9945.Kernel.Directory.Remove.remove(path)
    }
}
