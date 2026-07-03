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

// MARK: - POSIX-shared File.Flush policy
//
// swift-posix hosts only POSIX-shared policy wrappers (methods defined on
// syscalls implemented by every POSIX platform we support — Darwin and Linux).
//
// Darwin-only policy (fullFsync, barrierFsync, and the Darwin data() variant
// wrapping barrierFsync) lives in `Darwin.Kernel.File.Flush` in swift-darwin.
// Linux-only policy (data() wrapping fdatasync) lives in
// `Linux.Kernel.File.Flush` in swift-linux. See [PLAT-ARCH-002] and
// [PLAT-ARCH-008d].
extension POSIX.Kernel.File {
    /// File flush operations with EINTR retry policy.
    public enum Flush {}
}

// MARK: - Wave 3.5-Final-1 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.File.Flush {
    /// Flush error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.File.Flush.Error
}

extension POSIX.Kernel.File.Flush {
    /// Synchronizes a file's in-core state with storage device, automatically
    /// retrying on EINTR.
    ///
    /// Policy-aware wrapper around ``ISO_9945/Kernel/File/Flush/fsync(_:)``
    /// that handles signal interruption automatically. `fsync(2)` is available
    /// on every POSIX platform we support, so this wrapper is the single
    /// cross-POSIX entry point; `swift-kernel` delegates
    /// `ISO_9945.Kernel.File.Flush.flush(_:)` to it per [PLAT-ARCH-008e].
    ///
    /// - Parameter descriptor: The file descriptor.
    /// - Throws: ``Kernel/File/Flush/Error`` on failure (excluding EINTR).
    @inlinable
    public static func flush(_ descriptor: borrowing ISO_9945.Kernel.Descriptor) throws(ISO_9945.Kernel.File.Flush.Error) {
        while true {
            do throws(ISO_9945.Kernel.File.Flush.Error) {
                try ISO_9945.Kernel.File.Flush.fsync(descriptor)
                return
            } catch  where error.code.isInterrupted {
                continue  // Retry on EINTR
            }
        }
    }
}
