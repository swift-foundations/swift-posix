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

public import ISO_9945_Loader

// MARK: - POSIX Loader namespace
//
// Wave 3.5-8 (2026-05-02) — Item 4 sub-cycle 8 of post-Path-X cycles:
// Establishes POSIX.Loader namespace for method-wrapped siblings of
// ISO_9945.Loader typed Phase 1.5 forms (Library sub-namespace).
//
// **Different namespace level**: Loader is at `ISO_9945.Loader` (NOT
// `ISO_9945.Kernel.Loader`); POSIX wrappers go at `POSIX.Loader.Library`
// to mirror the iso-9945 namespace structure exactly. This is distinct
// from all other Wave 3.5 sub-cycles which target POSIX.Kernel.X.

extension POSIX {
    /// Dynamic library loader operations.
    public enum Loader: Sendable {}
}

// MARK: - Wave 3.5-Final-8 (2026-05-02) — value-type typealias for Loader.Error
//
// Loader.Error.Message struct chains transitively via the Error enum
// typealias per Final-4 sub-type transitivity insight. Loader root is
// L1-anchored (`ISO_9945.Loader = Loader_Primitives.Loader`); typealiasing
// to ISO_9945.Loader.Error preserves [PLAT-ARCH-008e] L3-policy → L2 → L1
// composition discipline (transitively resolves to L1 via iso-9945's
// Loader typealias).

extension POSIX.Loader {
    /// Loader error enum (Error.Message struct chains transitively) —
    /// typealias to canonical iso-9945 home (which transitively resolves
    /// to L1 `Loader_Primitives.Loader.Error`).
    public typealias Error = ISO_9945.Loader.Error
}
