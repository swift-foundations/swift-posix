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

// MARK: - POSIX.Kernel.File.Permissions value-type typealias
//
// Wave 3.5-Final-1 (2026-05-02) — value-type typealias enabling
// `Kernel.File.Permissions` consumer references to resolve after the
// Wave 3.5-Final-Atomic L3-unifier flip.

extension POSIX.Kernel.File {
    /// File permission bits (mode_t-equivalent value type) — typealias
    /// to canonical iso-9945 home.
    public typealias Permissions = ISO_9945.Kernel.File.Permissions
}
