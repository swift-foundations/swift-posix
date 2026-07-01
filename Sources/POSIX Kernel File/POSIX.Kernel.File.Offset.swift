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

// MARK: - POSIX.Kernel.File.Offset value-type typealias
//
// Wave 3.5-Final-1 (2026-05-02) — value-type typealias for File.Offset
// (off_t-equivalent typed value).

extension POSIX.Kernel.File {
    /// File offset (off_t-equivalent typed value) — typealias to canonical
    /// iso-9945 home.
    public typealias Offset = ISO_9945.Kernel.File.Offset
}
