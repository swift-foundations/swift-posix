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

// MARK: - POSIX User.Database policy
//
// Wave 3.5-8 (2026-05-02) — pass-through wrappers of
// ISO_9945.Kernel.User.Database typed forms (getpwnam/getpwuid).

extension POSIX.Kernel.User {
    /// User database lookup operations.
    public enum Database: Sendable {}
}

// MARK: - Wave 3.5-Final-8 (2026-05-02) — value-type typealias for Database.Entry
//
// User.Database is a fresh POSIX namespace-enum (not a typealias to
// iso-9945), so Database.Entry does NOT chain transitively — explicit
// nested typealias required. (Same architectural distinction Final-4
// articulated for non-typealiased parents.)

extension POSIX.Kernel.User.Database {
    /// User database entry (passwd struct wrapper) — typealias to canonical
    /// iso-9945 home.
    public typealias Entry = ISO_9945.Kernel.User.Database.Entry
}

extension POSIX.Kernel.User.Database {
    /// Looks up a user database entry by name.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/User/Database/find(name:)``.
    ///
    /// - Parameter name: The user name to look up.
    /// - Returns: The matching entry, or `nil` if not found.
    @inlinable
    public static func find(name: String) -> ISO_9945.Kernel.User.Database.Entry? {
        ISO_9945.Kernel.User.Database.find(name: name)
    }

    /// Looks up a user database entry by user ID.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/User/Database/find(uid:)``.
    ///
    /// - Parameter uid: The user ID to look up.
    /// - Returns: The matching entry, or `nil` if not found.
    @inlinable
    public static func find(uid: ISO_9945.Kernel.User.ID) -> ISO_9945.Kernel.User.Database.Entry? {
        ISO_9945.Kernel.User.Database.find(uid: uid)
    }
}
