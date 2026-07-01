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

// MARK: - POSIX.Kernel.Memory.Page value-type typealias
//
// Wave 3.5-Final-4 (2026-05-02) — value-type typealias for the typed
// page-size value at L1. The canonical home is `System.Page` in
// swift-system-primitives (post-refactor relocation from
// swift-memory-primitives — the Memory ⇄ System layering reversal that
// landed alongside the Memory.Alignment ⇄ System.Page.Size bridge).

extension POSIX.Kernel.Memory {
    /// Memory page (typed value with size + alignment) — typealias to
    /// the canonical L1 home in `swift-system-primitives`.
    public typealias Page = System.Page
}
