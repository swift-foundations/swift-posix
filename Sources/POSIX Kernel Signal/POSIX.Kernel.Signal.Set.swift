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

// MARK: - POSIX.Kernel.Signal.Set value-type typealias
//
// Wave 3.5-Final-6 (2026-05-02) — value-type typealias for Signal.Set
// (struct at iso-9945 — typed sigset_t wrapper).
//
// Qualified name `POSIX.Kernel.Signal.Set` resolves unambiguously vs
// Swift.Set (consumers reach via fully-qualified Kernel.Signal.Set or
// equivalent; matches existing iso-9945 ISO_9945.Kernel.Signal.Set
// resolution pattern).

extension POSIX.Kernel.Signal {
    /// Signal set (typed sigset_t wrapper struct) — typealias to canonical
    /// iso-9945 home.
    public typealias Set = ISO_9945.Kernel.Signal.Set
}
