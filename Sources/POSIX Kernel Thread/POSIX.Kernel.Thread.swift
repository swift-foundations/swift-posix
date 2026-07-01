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

public import ISO_9945_Kernel_Thread

// MARK: - POSIX Thread namespace
//
// Wave 3.5-7 (2026-05-01) — Item 4 sub-cycle 7 of post-Path-X cycles:
// Establishes POSIX.Kernel.Thread namespace for method-wrapped siblings of
// ISO_9945.Kernel.Thread typed Phase 1.5 STATIC forms.
//
// **Narrow scope per envelope Q1**: iso-9945 Kernel.Thread surface only;
// higher-level Thread.* types at swift-threads / swift-executors are
// L3-unifier domain (per [PLAT-ARCH-008e]) and explicitly OUT of scope.
//
// **Structural exception** — Mutex/Condition/Key/Handle are class/struct
// types with INSTANCE methods only; not method-wrappable at L3-policy via
// static extension. Same pattern as Wave 3.5-3 `Directory.Stream` (final
// class, not wrapped) and Wave 3.5-6 `Signal.Set.contains` (instance
// method on value type, not wrapped). Consumers reach Mutex/Condition/Key
// directly through the typealias chain (`Kernel.Thread.Mutex` resolves
// to `ISO_9945.Kernel.Thread.Mutex` via L3-unifier re-export).
//
// Mutex.Lock.immediate() throws is technically EINTR-rare on some pthread
// impls but is not method-wrappable at L3-policy regardless of
// EINTR-prone status (instance method on value type).
//
// **The only static methods at iso-9945 Kernel.Thread enum** (line 33 +
// 99 of ISO 9945.Kernel.Thread.swift) are `create` and `yield` — wrapped
// in companion files POSIX.Kernel.Thread.create.swift and
// POSIX.Kernel.Thread.yield.swift respectively.

extension POSIX.Kernel {
    /// Thread operations.
    public enum Thread: Sendable {}
}
