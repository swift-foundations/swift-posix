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

// MARK: - POSIX Memory.Map.Anonymous sub-namespace
//
// `mmap(2)` with MAP_ANON is NOT EINTR-prone — pure pass-through. The wrapper
// is gratuitous delegation but kept for API surface consistency under
// `Kernel.Memory.Map.Anonymous.X` (matches the `Kernel.Memory.Map.X` parent).
//
// Anonymous gets its own enum sub-namespace under `POSIX.Kernel.Memory.Map`
// (the namespace enum). One type per file — declaration here, sibling
// nested types stay on the parent enum (`POSIX.Kernel.Memory.Map.swift`).

extension POSIX.Kernel.Memory.Map {
    /// Anonymous mapping sub-namespace.
    public enum Anonymous {}
}

// MARK: - L3-policy method (gratuitous delegation, kept for API surface)

extension POSIX.Kernel.Memory.Map.Anonymous {
    /// Creates an anonymous memory mapping.
    ///
    /// Anonymous mappings are not backed by any file. They are
    /// initialized to zero and are typically used for heap allocations
    /// or shared memory.
    ///
    /// `mmap(2)` MAP_ANON is not EINTR-prone — pure pass-through delegation
    /// to L1 `Memory.Map.Anonymous.map(...)`.
    ///
    /// - Parameters:
    ///   - length: Number of bytes to map (must be > 0).
    ///   - protection: Memory protection flags (default: read/write).
    ///   - shared: Whether the mapping is shared (default: private).
    /// - Returns: A region describing the mapped memory.
    /// - Throws: ``Memory/Map/Error`` on failure.
    public static func map(
        length: Memory.Address.Count,
        protection: Memory.Map.Protection = [.read, .write],
        shared: Bool = false
    ) throws(Memory.Map.Error) -> Memory.Map.Region {
        try Memory.Map.Anonymous.map(length: length, protection: protection, shared: shared)
    }
}
