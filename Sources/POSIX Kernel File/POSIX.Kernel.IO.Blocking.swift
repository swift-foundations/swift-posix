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

// MARK: - POSIX.Kernel.IO.Blocking value-type typealias
//
// Wave 3.5-Final-1 (2026-05-02) — value-type typealias for the Blocking
// namespace (carries .Error and other sub-types via typealias transitivity).

extension POSIX.Kernel.IO {
    /// IO.Blocking namespace (carries Error and configuration types) —
    /// typealias to canonical iso-9945 home.
    public typealias Blocking = ISO_9945.Kernel.IO.Blocking
}
