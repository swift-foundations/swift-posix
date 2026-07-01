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

// MARK: - POSIX Directory policy
//
// Wave 3.5-3 (2026-05-01) — Item 4 sub-cycle 3 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Directory typed forms.
// `opendir(3)` is rare-EINTR (uses open(2) internally on some platforms);
// readdir / closedir / rewinddir are NOT EINTR-prone per POSIX spec.
//
// Directory.Stream is iso-9945's `final class` — instance methods
// (.close(), .next() -> Entry?) are reached directly through the typed-
// `open()` return type; no POSIX.Kernel.Directory.Stream typealias added
// per [feedback_no_gratuitous_l3_delegation].
//
// Directory.Error has abstract domain cases (notFound, permission,
// notDirectory, tooManyOpenFiles, io) + .platform; pattern-match-on-case
// .platform used for EINTR detection (matches Move.Error / File.Open.Error
// precedent from Wave 3.5-1/2).

extension POSIX.Kernel {
    /// Directory operations.
    public enum Directory: Sendable {}
}

// MARK: - Wave 3.5-Final-3 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.Directory {
    /// Directory error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.Directory.Error
}

extension POSIX.Kernel.Directory {
    /// Opens a directory for iteration using a raw `Path.Char` pointer,
    /// automatically retrying on EINTR.
    ///
    /// Pass-through wrapper around iso-9945's `@unsafe` open variant.
    /// `@unsafe` mirrors the iso-9945 form's caller-NUL-termination contract.
    /// EINTR retry handles the rare case where opendir's internal open(2)
    /// is signal-interrupted.
    ///
    /// - Parameter path: Null-terminated path pointer.
    /// - Returns: A directory stream for iteration (``ISO_9945/Kernel/Directory/Stream``).
    /// - Throws: ``ISO_9945/Kernel/Directory/Error`` on failure (excluding EINTR).
    @unsafe
    @inlinable
    public static func open(
        at path: UnsafePointer<Path.Char>
    ) throws(ISO_9945.Kernel.Directory.Error) -> ISO_9945.Kernel.Directory.Stream {
        while true {
            do throws(ISO_9945.Kernel.Directory.Error) {
                return try unsafe ISO_9945.Kernel.Directory.open(at: path)
            } catch {
                // Directory.Error has no .code accessor (domain cases abstract from POSIX
                // errno). Pattern-match on .platform — EINTR can only arrive there.
                if case .platform(let primitiveError) = error,
                   primitiveError.code.isInterrupted {
                    continue  // Retry on EINTR
                }
                throw error
            }
        }
    }

    /// Opens a directory for iteration using `Path`, automatically retrying
    /// on EINTR.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Directory/open(at:)-(borrowing_Path.Borrowed)``.
    /// EINTR retry handles the rare case where opendir's internal open(2)
    /// is signal-interrupted.
    ///
    /// - Parameter path: The path to the directory.
    /// - Returns: A directory stream for iteration (``ISO_9945/Kernel/Directory/Stream``).
    /// - Throws: ``ISO_9945/Kernel/Directory/Error`` on failure (excluding EINTR).
    @inlinable
    public static func open(
        at path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.Directory.Error) -> ISO_9945.Kernel.Directory.Stream {
        while true {
            do throws(ISO_9945.Kernel.Directory.Error) {
                return try ISO_9945.Kernel.Directory.open(at: path)
            } catch {
                if case .platform(let primitiveError) = error,
                   primitiveError.code.isInterrupted {
                    continue  // Retry on EINTR
                }
                throw error
            }
        }
    }
}
