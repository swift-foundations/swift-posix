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

// MARK: - POSIX Process namespace
//
// Wave 3.5-5 (2026-05-01) — Item 4 sub-cycle 5 of post-Path-X cycles:
// Establishes POSIX.Kernel.Process namespace for method-wrapped siblings of
// ISO_9945.Kernel.Process typed Phase 1.5 forms (Fork, Wait, Execute, Exit,
// Kill, Group, Session, Spawn sub-namespaces).
//
// Greenfield namespace — no pre-Phase-1.5 wrappers existed at swift-posix
// prior to this cycle (only exports.swift). Clean per-sub-namespace
// commits per [HANDOFF-019].
//
// Process.Error has public `.code` accessor + `.isInterrupted` semantic
// accessor, enabling canonical EINTR retry pattern (`catch where
// error.code.isInterrupted`) — first since Wave 3.5-1's IO.Read precedent.

extension POSIX.Kernel {
    /// Process operations.
    public enum Process: Sendable {}
}
