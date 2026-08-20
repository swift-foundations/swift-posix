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

import ISO_9945_Kernel_Signal

// MARK: - POSIX Signal namespace
//
// Wave 3.5-6 (2026-05-01) — Item 4 sub-cycle 6 of post-Path-X cycles:
// Establishes POSIX.Kernel.Signal namespace for method-wrapped siblings of
// ISO_9945.Kernel.Signal typed Phase 1.5 forms (Action, Mask, Send
// sub-namespaces).
//
// Greenfield namespace — no pre-Phase-1.5 wrappers existed at swift-posix
// prior to this cycle (only exports.swift). Clean per-sub-namespace
// commits per [HANDOFF-019].
//
// **No EINTR retry applied** — iso-9945 Signal namespace covers
// action/mask/send only; sigsuspend/sigwait/sigwaitinfo/sigtimedwait
// (the EINTR-prone POSIX signal operations) are not exposed at L2.
// All Signal wrappers are pure pass-through.
//
// Signal.Error structure (`.interrupted` case + Optional `.code` accessor
// + `.isInterrupted` accessor) supports canonical EINTR retry via
// `error.isInterrupted` if/when iso-9945 expands to wrap blocking-wait
// operations in a future cycle.

extension POSIX.Kernel {
    /// Signal operations.
    public enum Signal: Sendable {}
}
