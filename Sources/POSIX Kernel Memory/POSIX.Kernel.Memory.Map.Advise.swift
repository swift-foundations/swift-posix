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

// MARK: - POSIX Memory.Map.advise pointer overloads
//
// `madvise(2)` is NOT EINTR-prone — pure pass-through. Non-throwing. The two
// `@unsafe` raw-pointer overloads coexist with the typed
// `advise(addr: Memory.Address, ...)` on `POSIX.Kernel.Memory.Map` (the
// sibling file `POSIX.Kernel.Memory.Map.swift`) because they overload by
// parameter type.

extension POSIX.Kernel.Memory.Map {
    /// Advises the kernel about expected memory access patterns
    /// (mutable raw pointer).
    ///
    /// `madvise(2)` is not EINTR-prone — pure pass-through delegation to
    /// L1 `@unsafe Memory.Map.advise(addr: UnsafeMutableRawPointer, ...)`.
    @unsafe
    public static func advise(
        addr: UnsafeMutableRawPointer,
        length: Memory.Address.Count,
        advice: Memory.Map.Advice
    ) {
        unsafe Memory.Map.advise(addr: addr, length: length, advice: advice)
    }

    /// Advises the kernel about expected memory access patterns
    /// (immutable raw pointer).
    ///
    /// `madvise(2)` is not EINTR-prone — pure pass-through delegation to
    /// L1 `@unsafe Memory.Map.advise(addr: UnsafeRawPointer, ...)`.
    @unsafe
    public static func advise(
        addr: UnsafeRawPointer,
        length: Memory.Address.Count,
        advice: Memory.Map.Advice
    ) {
        unsafe Memory.Map.advise(addr: addr, length: length, advice: advice)
    }
}
