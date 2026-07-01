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

public import ISO_9945_Kernel_Memory

// MARK: - POSIX.Kernel.Memory.Allocation value-type typealias
//
// Wave 3.5-Final-4 (2026-05-02) — value-type typealias for Memory.Allocation
// (namespace at L1 swift-memory-primitives — alignment helpers, etc.).

extension POSIX.Kernel.Memory {
    /// Memory allocation namespace (alignment helpers) — typealias to
    /// canonical L1 home.
    public typealias Allocation = Memory.Allocation
}
