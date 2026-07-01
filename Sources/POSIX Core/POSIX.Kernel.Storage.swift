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

// MARK: - POSIX.Kernel.Storage value-type typealias
//
// Wave 3.5-Final-Atomic gap-fill (2026-05-02) — value-type typealias for
// `Kernel.Storage` namespace + nested `Storage.Error` (chains
// transitively per Final-4 sub-type insight).
//
// Discovered during Final-Atomic step 5 build verification: Storage is a
// pure-error namespace at iso-9945 Core (no method-wrapping rationale,
// hence not in any Wave 3.5-N envelope). Post-flip, consumers writing
// `Kernel.Storage.Error` (e.g., swift-kernel's Kernel.Failure.swift
// case `space(Kernel.Storage.Error)`) would fail to resolve without
// this gap-fill.
//
// Pure-error namespace pattern: namespace-enum at iso-9945 Core hosting
// only an Error sub-type. Same pattern as Permission (companion gap-fill).

extension POSIX.Kernel {
    /// Storage error namespace (Storage.Error chains transitively) —
    /// typealias to canonical iso-9945 home.
    public typealias Storage = ISO_9945.Kernel.Storage
}
