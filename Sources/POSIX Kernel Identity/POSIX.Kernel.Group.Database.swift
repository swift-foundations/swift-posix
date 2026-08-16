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

public import ISO_9945_Kernel_Identity

// MARK: - POSIX Group.Database policy
//
// Wave 3.5-8 (2026-05-02) — pass-through wrappers of
// ISO_9945.Kernel.Group.Database typed forms (getgrnam/getgrgid).

extension POSIX.Kernel.Group {
    /// Group database lookup operations.
    public enum Database: Sendable {}
}

// MARK: - Wave 3.5-Final-8 (2026-05-02) — value-type typealias for Database.Entry
//
// Group.Database is a fresh POSIX namespace-enum (not a typealias to
// iso-9945), so Database.Entry does NOT chain transitively — explicit
// nested typealias required. (Same architectural distinction Final-4
// articulated for non-typealiased parents.)

extension POSIX.Kernel.Group.Database {
    /// Group database entry (group struct wrapper) — typealias to canonical
    /// iso-9945 home.
    public typealias Entry = ISO_9945.Kernel.Group.Database.Entry
}

extension POSIX.Kernel.Group.Database {
    /// Looks up a group database entry by name.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/Group/Database/find(name:)``.
    ///
    /// - Parameter name: The group name to look up.
    /// - Returns: The matching entry, or `nil` if not found.
    @inlinable
    public static func find(
        name: String
    ) throws(ISO_9945.Kernel.Group.Database.Error) -> ISO_9945.Kernel.Group.Database.Entry? {
        try ISO_9945.Kernel.Group.Database.find(name: name)
    }

    /// Looks up a group database entry by group ID.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/Group/Database/find(gid:)``.
    ///
    /// - Parameter gid: The group ID to look up.
    /// - Returns: The matching entry, or `nil` if not found.
    @inlinable
    public static func find(
        gid: ISO_9945.Kernel.Group.ID
    ) throws(ISO_9945.Kernel.Group.Database.Error) -> ISO_9945.Kernel.Group.Database.Entry? {
        try ISO_9945.Kernel.Group.Database.find(gid: gid)
    }
}
