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

// MARK: - POSIX Group.Supplementary policy
//
// Wave 3.5-8 (2026-05-02) — pass-through wrapper of
// ISO_9945.Kernel.Group.Supplementary.get typed form (getgroups).

extension POSIX.Kernel.Group {
    /// Supplementary group ID operations.
    public enum Supplementary: Sendable {}
}

extension POSIX.Kernel.Group.Supplementary {
    /// Gets the supplementary group IDs of the calling process.
    ///
    /// Pass-through wrapper around ``ISO_9945/Kernel/Group/Supplementary/get()``.
    ///
    /// - Returns: The list of supplementary group IDs.
    /// - Throws: `Error_Primitives.Error` on failure.
    @inlinable
    public static func get() throws(Error_Primitives.Error) -> [ISO_9945.Kernel.Group.ID] {
        try ISO_9945.Kernel.Group.Supplementary.get()
    }
}
