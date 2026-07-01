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

// MARK: - POSIX User.Login policy
//
// Wave 3.5-8 (2026-05-02) — pass-through wrapper of
// ISO_9945.Kernel.User.Login.name typed form (getlogin).

extension POSIX.Kernel.User {
    /// Login name operations.
    public enum Login: Sendable {}
}

extension POSIX.Kernel.User.Login {
    /// Gets the login name of the current user.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/User/Login/name()``.
    ///
    /// - Returns: The login name, or `nil` if not available.
    @inlinable
    public static func name() -> String? {
        ISO_9945.Kernel.User.Login.name()
    }
}
