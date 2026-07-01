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

// MARK: - POSIX.Kernel.IO.Error value-type typealias
//
// Wave 3.5-Final-1 (2026-05-02) — value-type typealias enabling
// `Kernel.IO.Error` consumer references to resolve through L3-policy
// after Wave 3.5-Final-Atomic L3-unifier flip (`Kernel = POSIX.Kernel`).

extension POSIX.Kernel.IO {
    /// Umbrella IO error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.IO.Error
}
