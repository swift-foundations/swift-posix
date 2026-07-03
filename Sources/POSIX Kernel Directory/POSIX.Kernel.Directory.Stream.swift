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

public import ISO_9945_Kernel_Directory

// MARK: - POSIX.Kernel.Directory.Stream class typealias
//
// Wave 3.5-Final-3 (2026-05-02) — class typealias for Directory.Stream
// (`final class @unchecked Sendable` at iso-9945 — directory iteration
// stream returned by Directory.open(at:)).
//
// **Supersedes Wave 3.5-3 close-note position**: Wave 3.5-3 declared
// "no POSIX.Kernel.Directory.Stream typealias added" because consumers
// reached Stream via the L3-unifier typealias chain (Kernel.Directory.Stream
// resolved to ISO_9945.Kernel.Directory.Stream under the then-current
// `Kernel = ISO_9945.Kernel` typealias).
//
// After Wave 3.5-Final-Atomic flip (`Kernel = POSIX.Kernel`), the chain
// becomes `Kernel.Directory.Stream → POSIX.Kernel.Directory.Stream` —
// this typealias REQUIRED for Final-Atomic flip readiness. Same logic
// Final-1-Partial applied to other value-type sub-namespaces; Final-3
// applies it to the Stream class type as well.
//
// Wave 3.5-3's MARK comment in POSIX.Kernel.Directory.swift documents
// the original (point-in-time correct) "no Stream typealias" decision;
// supersession is documented here in this file's header + audit doc
// Final-3 close note (per principal Q3 disposition: leave historical
// MARK: comment untouched, document supersession in new file headers).

extension POSIX.Kernel.Directory {
    /// Directory iteration stream (final class) — typealias to canonical
    /// iso-9945 home.
    public typealias Stream = ISO_9945.Kernel.Directory.Stream
}
