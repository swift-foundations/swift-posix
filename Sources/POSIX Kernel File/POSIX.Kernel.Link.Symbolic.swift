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

// MARK: - POSIX Link.Symbolic policy
//
// Wave 3.5-2 (2026-05-01) — Item 4 sub-cycle 2 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Link.Symbolic typed forms.
// `symlink(2)` / `readlink(2)` are NOT EINTR-prone per POSIX spec —
// pure pass-through for namespace symmetry.

extension POSIX.Kernel.Link {
    /// Symbolic link operations.
    public enum Symbolic {}
}

// MARK: - Wave 3.5-Final-2 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.Link.Symbolic {
    /// Symbolic link error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.Link.Symbolic.Error
}

extension POSIX.Kernel.Link.Symbolic {
    /// Creates a symbolic link.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Link/Symbolic/create(target:at:)``.
    ///
    /// - Parameters:
    ///   - target: The path the symlink points to.
    ///   - linkPath: The path where the symlink will be created.
    /// - Throws: ``ISO_9945/Kernel/Link/Symbolic/Error`` on failure.
    @inlinable
    public static func create(
        target: borrowing Path.Borrowed,
        at linkPath: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.Link.Symbolic.Error) {
        try ISO_9945.Kernel.Link.Symbolic.create(target: target, at: linkPath)
    }

    /// Scoped access to symlink target bytes.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Link/Symbolic/withTargetBytes(at:_:)``.
    ///
    /// - Parameters:
    ///   - path: The path to the symbolic link.
    ///   - body: A closure that processes the target bytes. Non-throwing.
    /// - Returns: The result of the closure.
    /// - Throws: ``ISO_9945/Kernel/Link/Symbolic/Error`` on syscall failure.
    @inlinable
    public static func withTargetBytes<R: ~Copyable>(
        at path: borrowing Path.Borrowed,
        _ body: (Swift.Span<Path.Char>) -> R
    ) throws(ISO_9945.Kernel.Link.Symbolic.Error) -> R {
        try ISO_9945.Kernel.Link.Symbolic.withTargetBytes(at: path, body)
    }

    /// Scoped access to symlink target as a NUL-terminated view.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Link/Symbolic/withTarget(at:_:)``.
    ///
    /// - Parameters:
    ///   - path: The path to the symbolic link.
    ///   - body: A closure that processes the target view. Non-throwing.
    /// - Returns: The result of the closure.
    /// - Throws: ``ISO_9945/Kernel/Link/Symbolic/Error`` on syscall failure.
    @inlinable
    public static func withTarget<R: ~Copyable>(
        at path: borrowing Path.Borrowed,
        _ body: (borrowing String.Borrowed) -> R
    ) throws(ISO_9945.Kernel.Link.Symbolic.Error) -> R {
        try ISO_9945.Kernel.Link.Symbolic.withTarget(at: path, body)
    }

    /// Reads the target of a symbolic link, returning an allocated `String`.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Link/Symbolic/readTarget(at:)``.
    ///
    /// - Parameter path: The path to the symbolic link.
    /// - Returns: The target path as a `String`.
    /// - Throws: ``ISO_9945/Kernel/Link/Symbolic/Error`` on failure.
    @inlinable
    public static func readTarget(
        at path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.Link.Symbolic.Error) -> String {
        try ISO_9945.Kernel.Link.Symbolic.readTarget(at: path)
    }
}
