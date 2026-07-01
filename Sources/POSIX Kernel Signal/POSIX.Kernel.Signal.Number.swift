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

// MARK: - POSIX.Kernel.Signal.Number value-type typealias
//
// Wave 3.5-Final-6 (2026-05-02) — value-type typealias for Signal.Number
// (struct at iso-9945 — typed signal number wrapper).

extension POSIX.Kernel.Signal {
    /// Signal number (typed wrapper struct) — typealias to canonical
    /// iso-9945 home.
    public typealias Number = ISO_9945.Kernel.Signal.Number
}
