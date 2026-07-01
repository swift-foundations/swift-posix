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

// MARK: - POSIX.Kernel.Permission value-type typealias
//
// Wave 3.5-Final-Atomic gap-fill (2026-05-02) — value-type typealias for
// `Kernel.Permission` namespace + nested `Permission.Error` (chains
// transitively per Final-4 sub-type insight).
//
// Discovered during Final-Atomic step 5 build verification: Permission
// is a pure-error namespace at iso-9945 Core (no method-wrapping rationale,
// hence not in any Wave 3.5-N envelope). Post-flip, consumers writing
// `Kernel.Permission.Error` (e.g., swift-kernel's Kernel.Failure.swift
// case `permission(Kernel.Permission.Error)`) would fail to resolve
// without this gap-fill.
//
// Pure-error namespace pattern: namespace-enum at iso-9945 Core hosting
// only an Error sub-type. Same pattern as Storage (companion gap-fill).

extension POSIX.Kernel {
    /// Permission error namespace (Permission.Error chains transitively) —
    /// typealias to canonical iso-9945 home.
    public typealias Permission = ISO_9945.Kernel.Permission
}
