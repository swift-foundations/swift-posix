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

#if !os(Windows)

    @_spi(Syscall) public import ISO_9945_Kernel_Terminal
    @_spi(Syscall) public import POSIX_Kernel_Descriptor

    // MARK: - POSIX TTY policy
    //
    // `isatty(3)` / `ioctl(TIOCGWINSZ)` are NOT EINTR-prone per POSIX.1-2017 — pure
    // pass-through. There is no L3-policy substance for TTY queries.
    //
    // **Why a fresh `enum` for `TTY.Size` instead of `typealias` to L2?**
    //   - Extension on `POSIX.Kernel.TTY.Size` re-declaring `query(_:)` when
    //     `Size` is a typealias to `ISO_9945.Kernel.TTY.Size` recurses (Wave 3.5-
    //     Corrective same-signature overload resolution prefers the same-module
    //     form across a typealias collapse). The Path β fresh-enum shape gives a
    //     distinct nominal type at swift-posix; calls to
    //     `ISO_9945.Kernel.TTY.Size.query(...)` resolve unambiguously to L2.
    //   - `POSIX.Kernel.TTY` itself is already a fresh enum (not a typealias), so
    //     `extension POSIX.Kernel.TTY { static func isTTY(_:) }` lands on a
    //     distinct nominal type — no recursion there.
    //   - The `query(_:)` method is preserved here for API surface consistency
    //     (mirroring Memory.Map gratuitous-delegation precedent).

    extension POSIX.Kernel {
        /// Policy-aware POSIX terminal operations.
        ///
        /// L3-policy wrappers composing iso-9945 raw SPI forms per
        /// [PLAT-ARCH-008e] (L3-unifier composes L3-policy) and [PLAT-ARCH-005]
        /// revised (descriptor type lives at L3-policy).
        public enum TTY: Sendable {}
    }

    extension POSIX.Kernel.TTY {
        /// Terminal size — namespace enum hosting L3-policy methods.
        public enum Size {}
    }

    // MARK: - TTY Check

    extension POSIX.Kernel.TTY {
        /// Check if a descriptor refers to a terminal.
        ///
        /// L3-policy wrapper composing the L2 raw `isatty(fd)` SPI
        /// (`@_spi(Syscall) ISO_9945.Kernel.TTY.isTTY(fd:)`) with typed-
        /// descriptor unwrap. Per [PLAT-ARCH-005] / Path X Phase 1 prerequisite:
        /// L2 takes raw `Int32`; the typed-descriptor convenience lives here at
        /// L3-policy.
        ///
        /// This is a pure observation — returns `false` on error rather than
        /// throwing.
        ///
        /// - Parameter descriptor: The descriptor to check.
        /// - Returns: `true` if the descriptor refers to a terminal, `false` otherwise.
        public static func isTTY(_ descriptor: borrowing POSIX.Kernel.Descriptor) -> Bool {
            ISO_9945.Kernel.TTY.isTTY(descriptor)
        }
    }

    // MARK: - TTY Size Query

    extension POSIX.Kernel.TTY.Size {
        /// Query terminal size for the given descriptor.
        ///
        /// L3-policy wrapper composing the L2 raw `ioctl(TIOCGWINSZ)` SPI
        /// (`@_spi(Syscall) ISO_9945.Kernel.TTY.Size.query(fd:)`) with typed-
        /// descriptor unwrap. Per [PLAT-ARCH-005] / Path X Phase 1 prerequisite.
        ///
        /// - Parameter descriptor: The descriptor to query.
        /// - Returns: Terminal size in rows and columns.
        /// - Throws: ``Error_Primitives.Error`` if the ioctl call fails, such as when the descriptor is not a terminal.
        public static func query(_ descriptor: borrowing POSIX.Kernel.Descriptor) throws(Error_Primitives.Error) -> ISO_9945.Kernel.TTY.Size {
            try ISO_9945.Kernel.TTY.Size.query(descriptor)
        }
    }

#endif
