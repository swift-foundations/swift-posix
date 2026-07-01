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

// MARK: - POSIX.Kernel.Process.ID value-type typealias
//
// Wave 3.5-Final-5 (2026-05-02) — value-type typealias for Process.ID
// (struct at iso-9945 ISO 9945 Core/ISO 9945.Kernel.Process.ID.swift:19 —
// typed pid_t wrapper).

extension POSIX.Kernel.Process {
    /// Process ID (typed pid_t wrapper struct) — typealias to canonical
    /// iso-9945 home.
    public typealias ID = ISO_9945.Kernel.Process.ID
}
