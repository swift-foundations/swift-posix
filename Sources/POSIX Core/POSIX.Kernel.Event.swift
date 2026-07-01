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

// MARK: - POSIX.Kernel.Event value-type typealias
//
// Wave 3.5-Final-Atomic gap-fill (2026-05-02) — value-type typealias for
// `Kernel.Event` struct + nested `Event.{Interest, Options, ID}`
// (chain transitively per Final-4 sub-type insight).
//
// Discovered during Final-Atomic step 5 build verification: Event is a
// cross-platform value-type at iso-9945 Core (no method-wrapping rationale
// at swift-posix; the Driver/Source/etc. are at swift-kernel L3 directly).
// Hence not in any Wave 3.5-N envelope. Post-flip, consumers writing
// `Kernel.Event.Interest` / `Kernel.Event.Driver` / etc. (e.g.,
// swift-kernel's Kernel.Event.Driver.* files) would fail to resolve
// without this gap-fill.
//
// Same pure-value-type pattern as Permission / Storage gap-fills.

extension POSIX.Kernel {
    /// Event struct (cross-platform event correlation type; Event.{Interest,
    /// Options, ID} chain transitively) — typealias to canonical iso-9945
    /// home.
    public typealias Event = ISO_9945.Kernel.Event
}
