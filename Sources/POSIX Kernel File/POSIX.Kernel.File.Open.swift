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

// MARK: - POSIX File.Open policy
//
// `open(2)` can return EINTR for slow opens (FIFOs with no writer, network
// filesystems blocking, signal interruption during device file open). The
// L3-policy `open(...)` retries on EINTR via pattern-match on
// `Open.Error.platform` (Open.Error has no `.code` accessor — the canonical
// projection is via the `init(code:)` direction at iso-9945).
//
// **Why a fresh `enum` instead of Tagged or extension on iso-9945?**
//   - Extension on `ISO_9945.Kernel.File.Open` recurses (same-signature
//     overload resolution prefers the L3 form — Wave 3.5 issue, 16 sites).
//   - `Tagged<POSIX, ISO_9945.Kernel.File.Open>` with nested-type typealiases
//     causes `Error`/`Options` ambiguity: `Memory.Address.Error` declared on
//     `Tagged where Tag == Memory, RawValue == Ordinal` pollutes lookup
//     across all Tagged instantiations (constrained-extension nested types
//     are looked up irrespective of where-clause).
//   - A fresh nominal type at swift-posix solves both: distinct from iso-9945
//     (no recursion, calls to `ISO_9945.Kernel.File.Open.open(...)` resolve
//     unambiguously to L2), distinct from Tagged (no nested-type ambiguity).

extension POSIX.Kernel.File {
    /// File open operations — namespace enum hosting L3-policy methods.
    public enum Open {
        /// Open error type — typealias to canonical iso-9945 home.
        public typealias Error = ISO_9945.Kernel.File.Open.Error

        /// Open mode (read/write/append/etc.) — typealias.
        public typealias Mode = ISO_9945.Kernel.File.Open.Mode

        /// Open options (O_CREAT/O_EXCL/etc.) — typealias.
        public typealias Options = ISO_9945.Kernel.File.Open.Options

        // Note: `Open.Configuration` is defined at swift-kernel L3 (extension
        // on Kernel.File.Open); attaches to this enum via the typealias chain.
    }
}

// MARK: - L3-policy method (EINTR retry)

extension POSIX.Kernel.File.Open {
    /// Opens a file at the specified path, automatically retrying on EINTR.
    ///
    /// L3-policy: pattern-match-on-case `.platform` EINTR retry. Delegates to
    /// iso-9945's `open(...)` for the actual syscall.
    ///
    /// ## Descriptor Ownership
    ///
    /// The caller receives ownership of the returned descriptor and must
    /// close it explicitly via ``ISO_9945/Kernel/Close/close(_:)`` (or
    /// ``POSIX/Kernel/Close/close(_:)`` for the policy-aware wrapper).
    ///
    /// - Parameters:
    ///   - path: The file path to open (borrowed, zero-copy).
    ///   - mode: Read/write access mode (.read, .write, or .readWrite).
    ///   - options: Creation and behavior options (.create, .truncate, etc.).
    ///   - permissions: POSIX permissions for newly created files.
    /// - Returns: A file descriptor for the opened file.
    /// - Throws: ``ISO_9945/Kernel/File/Open/Error`` on failure (excluding EINTR).
    public static func open(
        path: borrowing Path.Borrowed,
        mode: ISO_9945.Kernel.File.Open.Mode,
        options: ISO_9945.Kernel.File.Open.Options,
        permissions: ISO_9945.Kernel.File.Permissions
    ) throws(ISO_9945.Kernel.File.Open.Error) -> ISO_9945.Kernel.Descriptor {
        while true {
            do throws(ISO_9945.Kernel.File.Open.Error) {
                return try ISO_9945.Kernel.File.Open.open(
                    path: path,
                    mode: mode,
                    options: options,
                    permissions: permissions
                )
            } catch {
                // Open.Error has cases including .platform(Error_Primitives.Error);
                // EINTR wraps in .platform(...). Pattern-match to detect EINTR —
                // Open.Error has no `.code` accessor.
                if case .platform(let primitiveError) = error,
                    primitiveError.code.isInterrupted
                {
                    continue  // Retry on EINTR
                }
                throw error
            }
        }
    }
}
