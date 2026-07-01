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

// MARK: - POSIX.Kernel.File.Clone value-type typealias
//
// Wave 3.5-Final-1 (2026-05-02) — value-type typealias for File.Clone
// (carries Behavior, Capability, Error, Result via typealias transitivity).

extension POSIX.Kernel.File {
    /// File clone namespace (with Behavior, Capability, Error, Result
    /// sub-types) — typealias to canonical iso-9945 home.
    public typealias Clone = ISO_9945.Kernel.File.Clone
}
