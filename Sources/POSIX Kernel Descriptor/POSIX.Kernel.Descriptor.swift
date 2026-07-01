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

@_spi(Syscall) public import ISO_9945_Core

// MARK: - POSIX Descriptor — typealias to L2-canonical ISO_9945.Kernel.Descriptor (Wave 4c-Socket Prerequisite, 2026-05-01)
//
// Per [PLAT-ARCH-005] revised (Wave 4c-Socket Prerequisite, 2026-05-01): when an
// L2 spec layer exists for the platform, the per-platform Descriptor is canonical
// at L2. POSIX has the iso-9945 spec layer, so `ISO_9945.Kernel.Descriptor` is
// the canonical type; `POSIX.Kernel.Descriptor` collapses to a typealias.
//
// ## Layering after Wave 4c-Socket Prerequisite
//
// | Layer | Site | Behavior |
// |---|---|---|
// | L1 swift-kernel-primitives | (no Descriptor type) | L1-types-only-no-exceptions per [PLAT-ARCH-008c] |
// | L2 swift-iso-9945 | `ISO_9945.Kernel.Descriptor` (canonical) | Native fd + close-on-deinit policy + typed close form + @_spi(Syscall) `init(_rawValue:)` and `_rawValue` accessor |
// | L3-policy swift-posix | `POSIX.Kernel.Descriptor` (typealias to L2) | Source-compat name; consumers writing `POSIX.Kernel.Descriptor` continue to compile |
// | L3-unifier swift-kernel | `Kernel.Descriptor = ISO_9945.Kernel.Descriptor` | Cross-platform name resolves directly to L2 canonical |
//
// ## Round-Trip Elimination
//
// Pre-collapse (the duplicate-Descriptor defect): L2 had typed `Close.close(_:consuming
// ISO_9945.Kernel.Descriptor)`; L3 had a parallel ~Copyable `POSIX.Kernel.Descriptor`
// struct. L3 wrappers extracted Int32 from L3 Descriptor → constructed L2 Descriptor
// via @_spi `init(_rawValue:)` → called L2 typed → mapped errors. Every L3 → L2
// typed call required this round-trip.
//
// Post-collapse: a single Descriptor type. L3 wrappers pass typed Descriptor directly
// to L2 typed forms (consuming or borrowing). Round-trip eliminated; typed-everywhere
// composition becomes mechanical.
//
// ## Source compatibility
//
// `POSIX.Kernel.Descriptor` continues to resolve as a public name; consumers writing
// `POSIX.Kernel.Descriptor.Validity.Error`, `POSIX.Kernel.Descriptor.Duplicate.Error`,
// `POSIX.Kernel.Descriptor.Interest`, etc. continue to compile (the typealias preserves
// nested type access). Equation / Hash / Validity / Duplicate extensions previously
// declared at L3-policy are now sourced from L2 (the parallel L3 declarations were
// duplicates of L2 and were deleted in this collapse).

extension POSIX.Kernel {
    /// POSIX file descriptor — typealias to the L2-canonical
    /// `ISO_9945.Kernel.Descriptor` per [PLAT-ARCH-005] revised.
    ///
    /// The `~Copyable` move-only wrapper lives at L2 swift-iso-9945. This
    /// typealias preserves the `POSIX.Kernel.Descriptor` source-compat name
    /// for consumers; nested types (`Validity`, `Duplicate`, `Interest`)
    /// resolve through the typealias.
    public typealias Descriptor = ISO_9945.Kernel.Descriptor
}
