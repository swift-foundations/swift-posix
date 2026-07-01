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

// MARK: - POSIX User.Real policy
//
// Wave 3.5-8 (2026-05-02) — pass-through wrappers of
// ISO_9945.Kernel.User.Real typed forms (getuid/setuid).

extension POSIX.Kernel.User {
    /// Real user ID operations.
    public enum Real: Sendable {}
}

extension POSIX.Kernel.User.Real {
    /// Gets the real user ID of the calling process.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/User/Real/id()``.
    ///
    /// - Returns: The real user ID.
    @inlinable
    public static func id() -> ISO_9945.Kernel.User.ID {
        ISO_9945.Kernel.User.Real.id()
    }

    /// Sets the real user ID of the calling process.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/User/Real/set(_:)``.
    ///
    /// - Parameter uid: The new real user ID.
    /// - Throws: `Error_Primitives.Error` on failure (EPERM if not privileged).
    @inlinable
    public static func set(_ uid: ISO_9945.Kernel.User.ID) throws(Error_Primitives.Error) {
        try ISO_9945.Kernel.User.Real.set(uid)
    }
}
