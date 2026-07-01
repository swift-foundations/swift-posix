// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-posix open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-posix project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

/// POSIX namespace for policy-aware kernel operations.
///
/// This module provides EINTR-safe wrappers around the raw POSIX syscalls
/// from `ISO_9945_Kernel`. These wrappers automatically retry on EINTR
/// (signal interruption), which is the expected behavior for most applications.
///
/// ## Architecture
///
/// ```
/// Layer 1 (Primitives): swift-*-primitives      - NO policy
/// Layer 2 (Standards):  swift-iso-9945          - POSIX spec, NO policy (can return EINTR)
/// Layer 3 (Foundations): swift-posix            - POSIX + policy (EINTR retry HERE)
/// ```
public enum POSIX {
    /// Policy-aware kernel operations with automatic EINTR retry.
    public enum Kernel {
        /// File operations namespace.
        public enum File {
            /// Wave 3.5-Final-Atomic gap-fill (2026-05-02): file handle
            /// (~Copyable struct at iso-9945 Core) — typealias to canonical
            /// home so cross-platform L3-unifier code referencing
            /// `Kernel.File.Handle` resolves post-flip.
            public typealias Handle = ISO_9945.Kernel.File.Handle
        }
    }
}
