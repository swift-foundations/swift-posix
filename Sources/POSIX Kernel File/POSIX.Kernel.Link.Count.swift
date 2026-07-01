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

// MARK: - POSIX.Kernel.Link.Count value-type typealias
//
// Wave 3.5-Final-2 (2026-05-02) — value-type typealias for Link.Count
// (Tagged<ISO_9945.Kernel.Link, Cardinal> at iso-9945 — link count
// for hard-link reference tracking).

extension POSIX.Kernel.Link {
    /// Hard link count (Tagged value type) — typealias to canonical
    /// iso-9945 home.
    public typealias Count = ISO_9945.Kernel.Link.Count
}
