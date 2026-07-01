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

public import ISO_9945_Kernel_Process

// MARK: - POSIX.Kernel.Process.Error value-type typealias
//
// Wave 3.5-Final-5 (2026-05-02) — value-type typealias for Process.Error
// (enum at iso-9945 with operation-tagged cases for fork/wait/execute/
// exit/kill/group/session/spawn). Error.Semantic nested enum chains
// transitively through this typealias.

extension POSIX.Kernel.Process {
    /// Process error type (enum with .Semantic nested enum chained
    /// transitively) — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.Process.Error
}
