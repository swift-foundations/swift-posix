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

public import ISO_9945_Kernel_Thread

// MARK: - POSIX.Kernel.Thread.Affinity value-type typealias
//
// Wave 3.5-Final-7 (2026-05-02) — value-type typealias for Thread.Affinity
// (struct Sendable, Equatable at iso-9945 — CPU-affinity descriptor).
//
// Affinity.{Error, Failure, Kind, Support} (4 enums) chain transitively
// per Final-4 Map-transitivity insight applied at sub-type level
// (typealiased struct parents propagate nested sub-types without explicit
// declaration).

extension POSIX.Kernel.Thread {
    /// Thread CPU affinity (struct; Affinity.{Error, Failure, Kind, Support}
    /// chain transitively) — typealias to canonical iso-9945 home.
    public typealias Affinity = ISO_9945.Kernel.Thread.Affinity
}
