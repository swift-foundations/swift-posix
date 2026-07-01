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

// MARK: - POSIX.Kernel.File.Copy value-type typealias
//
// Wave 3.5-Final-1 (2026-05-02) — value-type typealias for File.Copy
// (carries Error, Options via typealias transitivity). Note that
// File.Copy is empty-namespace at iso-9945 (no `public static func`
// per Wave 3.5-2 deferral); only its sub-types are referenced by
// consumers.

extension POSIX.Kernel.File {
    /// File copy namespace (with Error, Options sub-types) — typealias
    /// to canonical iso-9945 home.
    public typealias Copy = ISO_9945.Kernel.File.Copy
}
