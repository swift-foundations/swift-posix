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

// MARK: - POSIX.Kernel.Memory.Address value-type typealias
//
// Wave 3.5-Final-4 (2026-05-02) — value-type typealias for Memory.Address
// (struct at L1 swift-memory-primitives — typed memory address with Count
// nested type for arithmetic).

extension POSIX.Kernel.Memory {
    /// Memory address (typed value type) — typealias to canonical L1 home.
    public typealias Address = Memory.Address
}
