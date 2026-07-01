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

// MARK: - POSIX Process.Group policy
//
// Wave 3.5-5 (2026-05-01) — Item 4 sub-cycle 5 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Process.Group typed forms.
// `setpgid(2)` / `getpgid(2)` are NOT EINTR-prone per POSIX spec — pure
// pass-through for namespace symmetry.

extension POSIX.Kernel.Process {
    /// Process group operations.
    public enum Group: Sendable {}
}

// MARK: - Wave 3.5-Final-5 (2026-05-02) — value-type typealiases for nested types

extension POSIX.Kernel.Process.Group {
    /// Group ID (Tagged value type) — typealias to canonical iso-9945 home.
    public typealias ID = ISO_9945.Kernel.Process.Group.ID

    /// Group.Process selector enum (.current / .id) — typealias to
    /// canonical iso-9945 home.
    public typealias Process = ISO_9945.Kernel.Process.Group.Process

    /// Group.Target selector enum (.same / .id) — typealias to canonical
    /// iso-9945 home.
    public typealias Target = ISO_9945.Kernel.Process.Group.Target
}

extension POSIX.Kernel.Process.Group {
    /// Sets the process group of a process.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Process/Group/set(_:to:)``.
    ///
    /// - Parameters:
    ///   - process: Which process to modify.
    ///   - target: Target process group.
    /// - Throws: ``ISO_9945/Kernel/Process/Error`` on failure.
    @inlinable
    public static func set(
        _ process: ISO_9945.Kernel.Process.Group.Process,
        to target: ISO_9945.Kernel.Process.Group.Target
    ) throws(ISO_9945.Kernel.Process.Error) {
        try ISO_9945.Kernel.Process.Group.set(process, to: target)
    }

    /// Gets the process group of a process.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Process/Group/id(of:)``.
    ///
    /// - Parameter pid: Process ID (use `.current` for calling process).
    /// - Returns: The process group ID.
    /// - Throws: ``ISO_9945/Kernel/Process/Error`` on failure.
    @inlinable
    public static func id(
        of pid: ISO_9945.Kernel.Process.ID
    ) throws(ISO_9945.Kernel.Process.Error) -> ISO_9945.Kernel.Process.Group.ID {
        try ISO_9945.Kernel.Process.Group.id(of: pid)
    }
}
