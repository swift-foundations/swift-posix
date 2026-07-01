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

// MARK: - POSIX.Kernel.Device value-type typealias
//
// L3-policy typealias to the L2 canonical home per [PLAT-ARCH-005] tiered
// chain. `Kernel.Device` (L3-unifier) → `POSIX.Kernel.Device` (this file)
// → `ISO_9945.Kernel.Device` (canonical at swift-iso-9945, L2).

extension POSIX.Kernel {
    /// Filesystem device ID — typealias to canonical iso-9945 home.
    public typealias Device = ISO_9945.Kernel.Device
}
