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

// MARK: - POSIX User namespace
//
// Wave 3.5-8 (2026-05-02) — Item 4 sub-cycle 8 of post-Path-X cycles:
// Establishes POSIX.Kernel.User namespace for method-wrapped siblings of
// ISO_9945.Kernel.User typed Phase 1.5 forms (Real, Effective, Database,
// Login sub-namespaces).
//
// User identity operations throw `Error_Primitives.Error` directly (no
// domain Error type at iso-9945). Not EINTR-prone (uid ops are atomic).

extension POSIX.Kernel {
    /// User identity operations.
    public enum User: Sendable {}
}

// MARK: - Wave 3.5-Final-8 (2026-05-02) — value-type typealias for User.ID

extension POSIX.Kernel.User {
    /// User ID (Tagged value-type typealias) — typealias to canonical
    /// iso-9945 home (`Tagged<ISO_9945.Kernel.User, UInt32>`).
    public typealias ID = ISO_9945.Kernel.User.ID
}
