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

// MARK: - POSIX Group.Real policy
//
// Wave 3.5-8 (2026-05-02) — pass-through wrappers of
// ISO_9945.Kernel.Group.Real typed forms (getgid/setgid).

extension POSIX.Kernel.Group {
    /// Real group ID operations.
    public enum Real: Sendable {}
}

extension POSIX.Kernel.Group.Real {
    /// Gets the real group ID of the calling process.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/Group/Real/id()``.
    ///
    /// - Returns: The real group ID.
    @inlinable
    public static func id() -> ISO_9945.Kernel.Group.ID {
        ISO_9945.Kernel.Group.Real.id()
    }

    /// Sets the real group ID of the calling process.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/Group/Real/set(_:)``.
    ///
    /// - Parameter gid: The new real group ID.
    /// - Throws: `Error_Primitives.Error` on failure (EPERM if not privileged).
    @inlinable
    public static func set(_ gid: ISO_9945.Kernel.Group.ID) throws(Error_Primitives.Error) {
        try ISO_9945.Kernel.Group.Real.set(gid)
    }
}
