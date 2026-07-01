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

public import ISO_9945_Kernel_Process

// MARK: - POSIX Process.Session policy
//
// Wave 3.5-5 (2026-05-01) — Item 4 sub-cycle 5 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Process.Session typed forms.
// `setsid(2)` / `getsid(2)` are NOT EINTR-prone per POSIX spec — pure
// pass-through for namespace symmetry.

extension POSIX.Kernel.Process {
    /// Process session operations.
    public enum Session: Sendable {}
}

// MARK: - Wave 3.5-Final-5 (2026-05-02) — value-type typealias for Session.ID

extension POSIX.Kernel.Process.Session {
    /// Session ID (Tagged value type) — typealias to canonical iso-9945 home.
    public typealias ID = ISO_9945.Kernel.Process.Session.ID
}

extension POSIX.Kernel.Process.Session {
    /// Creates a new session with the calling process as leader.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Process/Session/create()``.
    ///
    /// The calling process becomes the leader of a new session, the leader
    /// of a new process group, and detached from any controlling terminal.
    ///
    /// - Returns: The new session ID.
    /// - Throws: ``ISO_9945/Kernel/Process/Error`` on failure.
    @inlinable
    public static func create() throws(ISO_9945.Kernel.Process.Error) -> ISO_9945.Kernel.Process.Session.ID {
        try ISO_9945.Kernel.Process.Session.create()
    }

    /// Gets the session ID of a process.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Process/Session/id(of:)``.
    ///
    /// - Parameter pid: Process ID (use `.current` for calling process).
    /// - Returns: The session ID.
    /// - Throws: ``ISO_9945/Kernel/Process/Error`` on failure.
    @inlinable
    public static func id(
        of pid: ISO_9945.Kernel.Process.ID
    ) throws(ISO_9945.Kernel.Process.Error) -> ISO_9945.Kernel.Process.Session.ID {
        try ISO_9945.Kernel.Process.Session.id(of: pid)
    }
}
