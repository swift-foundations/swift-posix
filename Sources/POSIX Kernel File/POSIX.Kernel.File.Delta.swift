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

public import ISO_9945_Kernel_File

// MARK: - POSIX.Kernel.File.Delta value-type typealias
//
// Tier 5-File-Offset-Size (2026-05-02) — value-type typealias for File.Delta
// (signed displacement between file offsets), completing the L3-policy chain
// for the File.Offset/Size/Delta typed-value triple per [PLAT-ARCH-005]
// L2-canonical-where-spec-layer-exists. Mirrors the Wave 3.5-Final-1
// standalone-Category-B precedent established for Offset (POSIX.Kernel.File.Offset)
// and Size (POSIX.Kernel.File.Size).

extension POSIX.Kernel.File {
    /// Signed displacement between file offsets — typealias to canonical
    /// iso-9945 home.
    public typealias Delta = ISO_9945.Kernel.File.Delta
}
