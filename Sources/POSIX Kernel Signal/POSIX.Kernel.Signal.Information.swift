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

// MARK: - POSIX.Kernel.Signal.Information value-type typealias
//
// Wave 3.5-Final-6 (2026-05-02) — value-type typealias for Signal.Information
// (struct at iso-9945 — siginfo_t wrapper). Information.Code nested struct
// chains transitively per Final-4 Map-transitivity insight applied at
// sub-type level.

extension POSIX.Kernel.Signal {
    /// Signal information (siginfo_t wrapper struct; Information.Code
    /// nested struct chains transitively) — typealias to canonical
    /// iso-9945 home.
    public typealias Information = ISO_9945.Kernel.Signal.Information
}
