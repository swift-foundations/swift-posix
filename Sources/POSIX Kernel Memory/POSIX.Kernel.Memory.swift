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

import ISO_9945_Kernel_Memory

// MARK: - POSIX Memory namespace
//
// Wave 3.5-4 (2026-05-01) — Item 4 sub-cycle 4 of post-Path-X cycles:
// Establishes POSIX.Kernel.Memory namespace for method-wrapped siblings of
// ISO_9945.Kernel.Memory typed Phase 1.5 forms (Map, Map.Anonymous,
// Map.Advise, Lock, Shared sub-namespaces).
//
// Pre-Wave-3.5 era files (POSIX.Kernel.Memory.{Map, Shared}) extended the
// iso-9945 Memory.{Map, Shared} namespaces directly — modernization in this
// cycle moves the new wrappers to extend POSIX.Kernel.Memory.{Map, Shared}
// per Wave 3.5 envelope's namespace-symmetry goal.
//
// Memory.Map.Error / Memory.Shared.Error / Memory.Lock.Error live at L1
// swift-memory-primitives with operation-tagged cases (.map, .unmap, .sync,
// .protect / .open, .unlink / etc.) carrying Error_Primitives.Error.Code +
// .exhausted catch-all. Pattern-match-on-case is the canonical EINTR-detection
// pattern (matches Wave 3.5-2 Move precedent).

extension POSIX.Kernel {
    /// Memory operations.
    public enum Memory: Sendable {}
}
