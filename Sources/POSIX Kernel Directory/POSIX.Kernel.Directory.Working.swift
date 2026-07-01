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

// MARK: - POSIX Directory.Working policy
//
// Wave 3.5-3 (2026-05-01) — Item 4 sub-cycle 3 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Directory.Working typed forms.
// `getcwd(3)` is NOT EINTR-prone per POSIX spec — pure pass-through for
// namespace symmetry.
//
// Working.Error has `.path(Path.Resolution.Error)` + `.platform`; matches
// File.Open.Error / Move.Error precedent. Pattern-match-on-case would be
// required if EINTR retry were needed, but getcwd is not EINTR-prone.

extension POSIX.Kernel.Directory {
    /// Working directory operations.
    public enum Working: Sendable {}
}

// MARK: - Wave 3.5-Final-3 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.Directory.Working {
    /// Working error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.Directory.Working.Error
}

extension POSIX.Kernel.Directory.Working {
    /// Fills the provided buffer with the current working directory path.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Directory/Working/current(into:)``.
    ///
    /// Low-level variant for callers that want to manage their own buffer.
    ///
    /// - Parameter buffer: Buffer to fill with the path. Must be large enough
    ///   to hold the path including null terminator.
    /// - Returns: Length of the path written (excluding null terminator).
    /// - Throws: ``ISO_9945/Kernel/Directory/Working/Error`` on failure.
    @inlinable
    public static func current(
        into buffer: UnsafeMutableBufferPointer<CChar>
    ) throws(ISO_9945.Kernel.Directory.Working.Error) -> Int {
        try unsafe ISO_9945.Kernel.Directory.Working.current(into: buffer)
    }

    /// Scoped access to current working directory bytes.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Directory/Working/withCurrentBytes(_:)``.
    ///
    /// Provides zero-copy access to the raw bytes returned by `getcwd(2)`.
    /// The closure receives a `Span` that does NOT include the NUL terminator.
    ///
    /// - Parameter body: A closure that processes the path bytes. Non-throwing.
    /// - Returns: The result of the closure.
    /// - Throws: ``ISO_9945/Kernel/Directory/Working/Error`` on syscall failure.
    @inlinable
    public static func withCurrentBytes<R: ~Copyable>(
        _ body: (Swift.Span<Path.Char>) -> R
    ) throws(ISO_9945.Kernel.Directory.Working.Error) -> R {
        try ISO_9945.Kernel.Directory.Working.withCurrentBytes(body)
    }

    /// Scoped access to current working directory as NUL-terminated view.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Directory/Working/withCurrent(_:)``.
    ///
    /// - Parameter body: A closure that processes the path view. Non-throwing.
    /// - Returns: The result of the closure.
    /// - Throws: ``ISO_9945/Kernel/Directory/Working/Error`` on syscall failure.
    @inlinable
    public static func withCurrent<R: ~Copyable>(
        _ body: (borrowing String.Borrowed) -> R
    ) throws(ISO_9945.Kernel.Directory.Working.Error) -> R {
        try ISO_9945.Kernel.Directory.Working.withCurrent(body)
    }

    /// Returns the current working directory as an allocated `String`.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Directory/Working/current()``.
    ///
    /// - Returns: The absolute path of the current working directory.
    /// - Throws: ``ISO_9945/Kernel/Directory/Working/Error`` on failure.
    @inlinable
    public static func current() throws(ISO_9945.Kernel.Directory.Working.Error) -> String {
        try ISO_9945.Kernel.Directory.Working.current()
    }
}
