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

public import ISO_9945_Kernel_Environment

// MARK: - POSIX Environment policy
//
// Wave 3.5-8 (2026-05-02) — Item 4 sub-cycle 8 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Environment typed Phase 1.5
// forms. `getenv(3)` / `setenv(3)` / `unsetenv(3)` are NOT EINTR-prone
// per POSIX spec — pure pass-through for namespace symmetry.
//
// Generic `R: ~Copyable` preserved on scoped variants. `entries()` returns
// `~Copyable ~Escapable Entries` struct.

extension POSIX.Kernel {
    /// Environment variable operations.
    public enum Environment: Sendable {}
}

// MARK: - Wave 3.5-Final-8 (2026-05-02) — value-type typealiases for nested types
//
// Environment is a fresh POSIX namespace-enum (not a typealias to
// iso-9945), so nested types need explicit typealiases. Error.Invalid
// chains transitively via the Error enum typealias per Final-4
// sub-type transitivity insight.

extension POSIX.Kernel.Environment {
    /// Environment error enum (Error.Invalid chains transitively) —
    /// typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.Environment.Error

    /// Environment entry (~Copyable, ~Escapable view over a single
    /// variable) — typealias to canonical iso-9945 home.
    public typealias Entry = ISO_9945.Kernel.Environment.Entry

    /// Environment entries (~Copyable, ~Escapable view over all
    /// variables) — typealias to canonical iso-9945 home.
    public typealias Entries = ISO_9945.Kernel.Environment.Entries
}

extension POSIX.Kernel.Environment {
    /// Returns a non-escapable view over all environment entries.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Environment/entries()``.
    ///
    /// - Returns: A `~Copyable ~Escapable Entries` view.
    @inlinable
    @_lifetime(immortal)
    public static func entries() -> ISO_9945.Kernel.Environment.Entries {
        ISO_9945.Kernel.Environment.entries()
    }

    /// Scoped access to environment variable bytes.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Environment/withValueBytes(_:_:)``.
    ///
    /// - Parameters:
    ///   - name: Pointer to null-terminated variable name.
    ///   - body: A closure that processes the value bytes. Non-throwing.
    /// - Returns: The result of the closure, or `nil` if the variable is not set.
    @inlinable
    public static func withValueBytes<R: ~Copyable>(
        _ name: UnsafePointer<String.Char>,
        _ body: (Swift.Span<String.Char>) -> R
    ) -> R? {
        unsafe ISO_9945.Kernel.Environment.withValueBytes(name, body)
    }

    /// Scoped access to environment variable as NUL-terminated view.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Environment/withValue(_:_:)``.
    ///
    /// - Parameters:
    ///   - name: Pointer to null-terminated variable name.
    ///   - body: A closure that processes the value view. Non-throwing.
    /// - Returns: The result of the closure, or `nil` if the variable is not set.
    @inlinable
    public static func withValue<R: ~Copyable>(
        _ name: UnsafePointer<String.Char>,
        _ body: (borrowing String.Borrowed) -> R
    ) -> R? {
        unsafe ISO_9945.Kernel.Environment.withValue(name, body)
    }

    /// Gets an environment variable as an allocated `String`.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Environment/get(_:)``.
    ///
    /// - Parameter name: Pointer to null-terminated variable name.
    /// - Returns: Owned copy of the value, or `nil` if not set.
    @inlinable
    public static func get(_ name: UnsafePointer<String.Char>) -> String? {
        unsafe ISO_9945.Kernel.Environment.get(name)
    }

    /// Sets an environment variable.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Environment/set(_:to:overwrite:)``.
    ///
    /// - Parameters:
    ///   - name: Pointer to null-terminated variable name.
    ///   - value: Pointer to null-terminated value.
    ///   - overwrite: If true, overwrite existing value.
    /// - Throws: ``ISO_9945/Kernel/Environment/Error`` on failure.
    @inlinable
    public static func set(
        _ name: UnsafePointer<String.Char>,
        to value: UnsafePointer<String.Char>,
        overwrite: Bool = true
    ) throws(ISO_9945.Kernel.Environment.Error) {
        try unsafe ISO_9945.Kernel.Environment.set(name, to: value, overwrite: overwrite)
    }

    /// Unsets an environment variable.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Environment/unset(_:)``.
    ///
    /// - Parameter name: Pointer to null-terminated variable name.
    /// - Throws: ``ISO_9945/Kernel/Environment/Error`` on failure.
    @inlinable
    public static func unset(_ name: UnsafePointer<String.Char>) throws(ISO_9945.Kernel.Environment.Error) {
        try unsafe ISO_9945.Kernel.Environment.unset(name)
    }
}
