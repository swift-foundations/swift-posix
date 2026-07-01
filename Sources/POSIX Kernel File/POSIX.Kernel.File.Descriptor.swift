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

// MARK: - POSIX.Kernel.File.Descriptor value-type typealias
//
// Wave 3.5-Final-1 (2026-05-02) — value-type typealias for File.Descriptor.
// At iso-9945, `ISO_9945.Kernel.File.Descriptor` is itself a typealias to
// `ISO_9945.Kernel.Descriptor` (the canonical L2 ~Copyable struct).
// Typealias transitivity preserves the chain.

extension POSIX.Kernel.File {
    /// File descriptor (typealias chain to L2 canonical Descriptor) —
    /// typealias to canonical iso-9945 home.
    public typealias Descriptor = ISO_9945.Kernel.File.Descriptor
}
