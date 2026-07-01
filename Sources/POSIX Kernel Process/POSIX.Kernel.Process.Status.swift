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

// MARK: - POSIX.Kernel.Process.Status value-type typealias
//
// Wave 3.5-Final-5 (2026-05-02) — value-type typealias for Process.Status
// (struct at iso-9945 — process exit/signal status with nested types
// Core, Classification, Exit, Stop, Terminating). All 5 nested types
// chain transitively through this typealias (per Final-4 Map-transitivity
// insight applied at sub-type level).

extension POSIX.Kernel.Process {
    /// Process status (struct with nested Core/Classification/Exit/Stop/
    /// Terminating types — all chain transitively) — typealias to
    /// canonical iso-9945 home.
    public typealias Status = ISO_9945.Kernel.Process.Status
}
