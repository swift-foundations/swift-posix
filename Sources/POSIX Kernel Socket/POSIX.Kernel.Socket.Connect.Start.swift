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

extension POSIX.Kernel.Socket.Connect {
    /// The immediate result of starting a reactive connection attempt.
    public enum Start: Sendable {
        /// The connection completed synchronously.
        case connected

        /// The connection remains in progress and must be finished after readiness.
        case pending
    }
}
