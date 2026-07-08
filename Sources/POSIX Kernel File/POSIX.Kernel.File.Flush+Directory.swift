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

@_spi(Syscall) public import ISO_9945_Kernel_File
public import Path_Primitives

// MARK: - POSIX directory(path:) — open(O_RDONLY) + fsync + close composition

extension POSIX.Kernel.File.Flush {
    /// Persists directory entries (rename visibility) to storage, automatically
    /// retrying on EINTR.
    ///
    /// Composes ``ISO_9945/Kernel/File/Open/open(path:mode:options:permissions:)``
    /// + ``POSIX/Kernel/File/Flush/flush(_:)`` + automatic close via
    /// `ISO_9945.Kernel.Descriptor.deinit`. The directory is opened with `O_CLOEXEC` so
    /// it does not leak across `exec`.
    ///
    /// ## EINTR
    /// Both the open and the flush leg retry on EINTR. The flush leg inherits
    /// retry behavior from ``POSIX/Kernel/File/Flush/flush(_:)``.
    ///
    /// - Parameter path: The directory path (borrowed view).
    /// - Throws: `ISO_9945.Kernel.File.Flush.Error` on failure. Open errors map to `Error`:
    ///   `handle` and `io` carry losslessly; `path`, `permission`, and `space`
    ///   flatten to `.platform(_:)` with a canonical POSIX code (`ENOENT`,
    ///   `EACCES`, `ENOSPC`).
    @inlinable
    public static func directory(path: borrowing Path.Borrowed) throws(ISO_9945.Kernel.File.Flush.Error) {
        let fd: ISO_9945.Kernel.Descriptor
        do throws(ISO_9945.Kernel.File.Open.Error) {
            fd = try _openForDirectoryFlush(path: path)
        } catch {
            // Map ISO_9945.Kernel.File.Open.Error -> ISO_9945.Kernel.File.Flush.Error.
            // Direct cases (handle, io) carry losslessly. Structural cases
            // (path, permission, space) carry no .code accessor on their
            // sub-error, so they flatten to .platform with a canonical POSIX
            // code naming the category — strictly less informative than the
            // raw errno but sufficient for consumer dispatch via
            // `code.isNotFound` / `isPermissionDenied` / `isNoSpace`.
            switch error {
            case .handle(let e): throw .handle(e)
            case .path: throw .platform(Error_Primitives.Error(code: .POSIX.ENOENT))
            case .platform(let e): throw .platform(e)
            }
        }
        try flush(fd)
        // fd auto-closes via ISO_9945.Kernel.Descriptor.deinit at end of scope.
    }

    /// Opens a directory for flushing, retrying on EINTR during the open syscall.
    @inlinable
    package static func _openForDirectoryFlush(
        path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.File.Open.Error) -> ISO_9945.Kernel.Descriptor {
        while true {
            do throws(ISO_9945.Kernel.File.Open.Error) {
                return try ISO_9945.Kernel.File.Open.open(
                    path: path,
                    mode: .read,
                    options: [.execClose],
                    permissions: .none
                )
            } catch {
                if case .platform(let e) = error, e.code.isInterrupted {
                    continue  // Retry on EINTR
                }
                throw error
            }
        }
    }
}
