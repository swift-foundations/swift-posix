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

public import ISO_9945_Kernel_Directory

// MARK: - POSIX.Kernel.Directory.Entry value-type typealias
//
// Wave 3.5-Final-3 (2026-05-02) — value-type typealias for Directory.Entry
// (struct at iso-9945 — directory entry record returned by Stream.next()).

extension POSIX.Kernel.Directory {
    /// Directory entry (struct value type returned by Stream.next()) —
    /// typealias to canonical iso-9945 home.
    public typealias Entry = ISO_9945.Kernel.Directory.Entry
}
