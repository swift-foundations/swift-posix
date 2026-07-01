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

public import ISO_9945_Kernel_Memory

// MARK: - POSIX Memory.Map policy
//
// `mmap(2)` / `munmap(2)` / `mprotect(2)` / `madvise(2)` are NOT EINTR-prone
// per POSIX spec — pure pass-through. `msync(2)` IS EINTR-prone — preserved
// pattern-match-on-case `.sync(let code)` retry per Wave 3.5-Final-4 semantic.
//
// **Why a fresh `enum` instead of typealias to L1 `Memory.Map`?**
//   - Extension on `Memory.Map` re-declaring `sync` recurses (same-signature
//     overload resolution prefers the L3 form — Wave 3.5 issue).
//   - `Tagged<POSIX, Memory.Map>` with nested-type typealiases collides with
//     `Memory.Address.Error` (constrained-extension nested-type lookup
//     ignores where-clause — see `POSIX.Kernel.File.Open.swift` for details).
//   - Enum gives a distinct nominal type at swift-posix; static methods
//     delegate to L1 cleanly. The `map`/`unmap`/`protect`/`advise` methods
//     are gratuitous delegations preserved here for API surface consistency
//     (so consumers can use a single namespace path for all map ops via
//     `Kernel.Memory.Map.X`).

extension POSIX.Kernel.Memory {
    /// Memory mapping operations — namespace enum hosting L3-policy methods.
    public enum Map {
        /// Mapped memory region (typealias to canonical L1 home).
        public typealias Region = Memory.Map.Region

        /// Memory map error (typealias to canonical L1 home).
        public typealias Error = Memory.Map.Error

        /// Memory protection flags (typealias to canonical L1 home).
        public typealias Protection = Memory.Map.Protection

        /// Memory map options (typealias to canonical L1 home).
        public typealias Options = Memory.Map.Options

        /// Memory map sync sub-namespace (typealias to canonical L1 home).
        public typealias Sync = Memory.Map.Sync

        /// Memory map advice (typealias to canonical L1 home).
        public typealias Advice = Memory.Map.Advice

        /// Memory map access mode (typealias to canonical L1 home).
        public typealias Access = Memory.Map.Access

        /// Memory map sharing mode (typealias to canonical L1 home).
        public typealias Sharing = Memory.Map.Sharing

        /// Memory map safety mode (typealias to canonical L1 home).
        public typealias Safety = Memory.Map.Safety

        // Note: `Anonymous` sub-namespace declared in
        // `POSIX.Kernel.Memory.Map.Anonymous.swift` (one type per file).
    }
}

// MARK: - L3-policy methods

extension POSIX.Kernel.Memory.Map {
    /// Maps memory into the process address space using a typed descriptor.
    ///
    /// `mmap(2)` is not EINTR-prone — pure pass-through delegation to L1.
    public static func map(
        addr: Memory.Address? = nil,
        length: Memory.Address.Count,
        protection: Memory.Map.Protection,
        flags: Memory.Map.Options,
        descriptor: borrowing ISO_9945.Kernel.Descriptor = .invalid,
        offset: ISO_9945.Kernel.File.Offset = .zero
    ) throws(Memory.Map.Error) -> Memory.Address {
        try Memory.Map.map(
            addr: addr,
            length: length,
            protection: protection,
            flags: flags,
            descriptor: descriptor,
            offset: offset
        )
    }

    /// Unmaps a previously mapped region by address+length.
    ///
    /// `munmap(2)` is not EINTR-prone — pure pass-through delegation to L1.
    public static func unmap(
        addr: Memory.Address,
        length: Memory.Address.Count
    ) throws(Memory.Map.Error) {
        try Memory.Map.unmap(addr: addr, length: length)
    }

    /// Unmaps a mapped region.
    ///
    /// `munmap(2)` is not EINTR-prone — pure pass-through delegation to L1.
    public static func unmap(_ region: Memory.Map.Region) throws(Memory.Map.Error) {
        try Memory.Map.unmap(region)
    }

    /// Synchronizes a mapped region to disk, automatically retrying on EINTR.
    ///
    /// L3-policy EINTR retry: `msync(2)` IS EINTR-prone. Pattern-match on case
    /// `.sync(let code)` per Wave 3.5-Final-4 semantic — Memory.Map.Error has
    /// operation-tagged cases (no `.code` accessor); EINTR for sync arrives
    /// only through `.sync(...)`.
    public static func sync(
        addr: Memory.Address,
        length: Memory.Address.Count,
        flags: Memory.Map.Sync.Options = .sync
    ) throws(Memory.Map.Error) {
        while true {
            do throws(Memory.Map.Error) {
                try Memory.Map.sync(addr: addr, length: length, flags: flags)
                return
            } catch {
                if case .sync(let code) = error, code.isInterrupted {
                    continue  // Retry on EINTR
                }
                throw error
            }
        }
    }

    /// Changes the protection on a mapped region.
    ///
    /// `mprotect(2)` is not EINTR-prone — pure pass-through delegation to L1.
    public static func protect(
        addr: Memory.Address,
        length: Memory.Address.Count,
        protection: Memory.Map.Protection
    ) throws(Memory.Map.Error) {
        try Memory.Map.protect(addr: addr, length: length, protection: protection)
    }

    /// Advises the kernel about expected access patterns.
    ///
    /// `madvise(2)` is not EINTR-prone — pure pass-through delegation to L1.
    /// Non-throwing.
    public static func advise(
        addr: Memory.Address,
        length: Memory.Address.Count,
        advice: Memory.Map.Advice
    ) {
        Memory.Map.advise(addr: addr, length: length, advice: advice)
    }
}
