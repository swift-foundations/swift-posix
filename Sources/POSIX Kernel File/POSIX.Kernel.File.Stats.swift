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

// MARK: - POSIX File.Stats policy (deliberately empty)
//
// All stat-family syscalls (`fstat(2)` / `stat(2)` / `lstat(2)` / `fstatat(2)`)
// are NOT EINTR-prone per POSIX.1-2017 — pure pass-through. There is no L3-policy
// substance for Stats, so the L3 wrapper would be a gratuitous delegation
// (per `feedback_no_gratuitous_l3_delegation`).
//
// The pre-Wave-3.5-Corrective cross-module extension that re-declared the
// stat methods at this layer was a source of the infinite-recursion sites
// (Swift's overload resolution preferred the L3 same-signature form).
// Path B disposition: keep only the namespace typealias.
//
// Consumers calling `Kernel.File.Stats.X` resolve through the typealias chain
// `Kernel.File.Stats → POSIX.Kernel.File.Stats → ISO_9945.Kernel.File.Stats`
// (with `Kernel = POSIX.Kernel` Final-Atomic flip) directly to iso-9945's
// public static methods (now plain `public` post-Phase-1 SPI revert).
// Nested types (Error, Kind) and field accessors (size, type, permissions,
// uid, gid, inode, device, linkCount, accessTime, modificationTime,
// changeTime) flow through the typealias to their canonical iso-9945 home.

extension POSIX.Kernel.File {
    /// File status info (typealias to canonical iso-9945 type).
    ///
    /// No L3 wrapper — stat syscalls are not EINTR-prone, no policy substance
    /// (per `feedback_no_gratuitous_l3_delegation`).
    public typealias Stats = ISO_9945.Kernel.File.Stats
}
