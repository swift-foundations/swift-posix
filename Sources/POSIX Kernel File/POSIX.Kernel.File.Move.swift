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

// MARK: - POSIX File.Move policy
//
// Wave 3.5-2 (2026-05-01) — Item 4 sub-cycle 2 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.File.Move typed forms.
// `rename(2)` / `renameat(2)` are EINTR-prone in rare cases (long renames
// across filesystem boundaries, signal interruption). Apply EINTR retry.
//
// Move.Error is enum with 11 domain cases (notFound, permission,
// crossDevice, etc.) + .platform(Error_Primitives.Error) catch-all.
// EINTR can only come through .platform; pattern-match-on-case used
// for EINTR detection (Move.Error has no `.code` accessor — domain
// cases abstract away from POSIX errno).

extension POSIX.Kernel.File {
    /// File move (rename) operations with EINTR retry policy.
    public enum Move {}
}

// MARK: - Wave 3.5-Final-1 (2026-05-02) — value-type typealias for nested Error

extension POSIX.Kernel.File.Move {
    /// Move error type — typealias to canonical iso-9945 home.
    public typealias Error = ISO_9945.Kernel.File.Move.Error
}

extension POSIX.Kernel.File.Move {
    /// Moves/renames a file or directory using `Path`, automatically
    /// retrying on EINTR.
    ///
    /// Policy-aware wrapper around
    /// ``ISO_9945/Kernel/File/Move/move(from:to:)-(borrowing_Path.Borrowed,_borrowing_Path.Borrowed)``.
    ///
    /// - Parameters:
    ///   - oldPath: The current path.
    ///   - newPath: The new path.
    /// - Throws: ``ISO_9945/Kernel/File/Move/Error`` on failure (excluding EINTR).
    @inlinable
    public static func move(
        from oldPath: borrowing Path.Borrowed,
        to newPath: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.File.Move.Error) {
        while true {
            do throws(ISO_9945.Kernel.File.Move.Error) {
                try ISO_9945.Kernel.File.Move.move(from: oldPath, to: newPath)
                return
            } catch {
                // Move.Error has no .code accessor (domain cases abstract from POSIX
                // errno). Pattern-match on .platform — EINTR can only arrive there.
                if case .platform(let primitiveError) = error,
                   primitiveError.code.isInterrupted {
                    continue  // Retry on EINTR
                }
                throw error
            }
        }
    }

    /// Moves/renames a file or directory using raw `Path.Char` pointers,
    /// automatically retrying on EINTR.
    ///
    /// Policy-aware wrapper around iso-9945's `@unsafe` move variant.
    /// `@unsafe` mirrors the iso-9945 form's caller-NUL-termination contract.
    ///
    /// - Parameters:
    ///   - oldPath: Null-terminated path pointer for the current path.
    ///   - newPath: Null-terminated path pointer for the new path.
    /// - Throws: ``ISO_9945/Kernel/File/Move/Error`` on failure (excluding EINTR).
    @unsafe
    @inlinable
    public static func move(
        from oldPath: UnsafePointer<Path.Char>,
        to newPath: UnsafePointer<Path.Char>
    ) throws(ISO_9945.Kernel.File.Move.Error) {
        while true {
            do throws(ISO_9945.Kernel.File.Move.Error) {
                try unsafe ISO_9945.Kernel.File.Move.move(from: oldPath, to: newPath)
                return
            } catch {
                if case .platform(let primitiveError) = error,
                   primitiveError.code.isInterrupted {
                    continue  // Retry on EINTR
                }
                throw error
            }
        }
    }

    /// Moves/renames a file or directory relative to directory descriptors,
    /// automatically retrying on EINTR.
    ///
    /// Policy-aware wrapper around the typed `renameat(2)` form taking
    /// `borrowing Descriptor` pairs and `UnsafePointer<Path.Char>` path
    /// components.
    ///
    /// - Parameters:
    ///   - oldDescriptor: Directory descriptor for the old path.
    ///   - oldPath: The current path component (null-terminated).
    ///   - newDescriptor: Directory descriptor for the new path.
    ///   - newPath: The new path component (null-terminated).
    /// - Throws: ``ISO_9945/Kernel/File/Move/Error`` on failure (excluding EINTR).
    @inlinable
    public static func move(
        from oldDescriptor: borrowing ISO_9945.Kernel.Descriptor,
        oldPath: UnsafePointer<Path.Char>,
        to newDescriptor: borrowing ISO_9945.Kernel.Descriptor,
        newPath: UnsafePointer<Path.Char>
    ) throws(ISO_9945.Kernel.File.Move.Error) {
        while true {
            do throws(ISO_9945.Kernel.File.Move.Error) {
                try unsafe ISO_9945.Kernel.File.Move.move(
                    from: oldDescriptor,
                    oldPath: oldPath,
                    to: newDescriptor,
                    newPath: newPath
                )
                return
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
