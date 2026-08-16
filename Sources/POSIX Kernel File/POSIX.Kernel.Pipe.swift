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

// MARK: - POSIX Pipe policy
//
// Wave 3.5-1 (2026-05-01) — Item 4 of post-Path-X cycles:
// Method-wrapped sibling of `ISO_9945.Kernel.Pipe.pipe()` with EINTR retry.
// pipe(2) is rarely interrupted in practice but EINTR is in the POSIX
// spec for the syscall; the retry wrapper matches the established
// POSIX.Kernel pattern (see POSIX.Kernel.IO.Read.swift) for consistency.

extension POSIX.Kernel {
    /// Pipe operations with EINTR retry policy.
    public enum Pipe {}
}

extension POSIX.Kernel.Pipe {
    /// Wave 3.5-Final-Atomic gap-fill (2026-05-02): pipe descriptor pair
    /// (Tagged<Pipe, Pair<Descriptor, Descriptor>> at iso-9945) — typealias
    /// to canonical home so cross-platform L3-unifier code referencing
    /// `Kernel.Pipe.Descriptors` resolves post-flip.
    public typealias Descriptors = ISO_9945.Kernel.Pipe.Descriptors

    /// Wave 3.5-Final-Atomic gap-fill (2026-05-02): pipe error.
    public typealias Error = ISO_9945.Kernel.Pipe.Error
}

extension POSIX.Kernel.Pipe {
    /// Creates an anonymous pipe, automatically retrying on EINTR.
    ///
    /// Policy-aware wrapper around ``ISO_9945/Kernel/Pipe/pipe()``.
    ///
    /// Returns a pair of file descriptors: `read` for the read end and
    /// `write` for the write end.
    ///
    /// - Returns: The read and write descriptors for the pipe.
    /// - Throws: ``ISO_9945/Kernel/Pipe/Error`` on failure (excluding EINTR).
    @inlinable
    public static func pipe() throws(ISO_9945.Kernel.Pipe.Error) -> ISO_9945.Kernel.Pipe.Descriptors
    {
        while true {
            do throws(ISO_9945.Kernel.Pipe.Error) {
                return try ISO_9945.Kernel.Pipe.pipe()
            } catch  where error.code.isInterrupted {
                continue  // Retry on EINTR
            }
        }
    }
}
