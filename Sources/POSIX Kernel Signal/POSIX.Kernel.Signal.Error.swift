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

public import ISO_9945_Kernel_Signal

// MARK: - POSIX.Kernel.Signal.Error value-type typealias
//
// Wave 3.5-Final-6 (2026-05-02) — value-type typealias for Signal.Error
// (enum at iso-9945 with operation-tagged cases for set/mask/action/send
// + .interrupted dedicated case). Error.Semantic nested enum chains
// transitively.

extension POSIX.Kernel.Signal {
    /// Signal error type (enum with .Semantic nested enum chained
    /// transitively) — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.Signal.Error
}
