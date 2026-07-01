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

// MARK: - POSIX.Kernel.Thread.Condition value-type typealias
//
// Wave 3.5-Final-7 (2026-05-02) — value-type typealias for Thread.Condition
// (final class @unchecked Sendable at iso-9945 — pthread_cond_t wrapper).
//
// Wave 3.5-7 supersession: Wave 3.5-7's structural-exception framing
// declared Condition "not method-wrappable at L3-policy" (instance-method-
// only type). That framing remains correct for METHOD-WRAPPING. Wave
// 3.5-Final-7 addresses a different concern — typealiases for
// type-annotation access post-Final-Atomic flip (`Kernel = POSIX.Kernel`).
// Same supersession pattern as Final-3's Stream typealias supersession of
// Wave 3.5-3.

extension POSIX.Kernel.Thread {
    /// Condition variable (pthread_cond_t wrapper final class) — typealias
    /// to canonical iso-9945 home.
    public typealias Condition = ISO_9945.Kernel.Thread.Condition
}
