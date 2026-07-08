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

    // MARK: - POSIX Termios policy
    //
    // `tcgetattr(2)` / `tcsetattr(2)` are NOT EINTR-prone per POSIX.1-2017 — pure
    // pass-through. There is no L3-policy substance for termios.
    //
    // **Why a fresh `enum` instead of `typealias` to ISO_9945.Kernel.Termios.Attributes?**
    //   - Extension on `POSIX.Kernel.Termios.Attributes` re-declaring `get(_:)`
    //     when `Attributes` is a typealias to L2 recurses (Wave 3.5-Corrective
    //     same-signature overload resolution prefers the same-module form across
    //     a typealias collapse). The Path β fresh-enum shape gives a distinct
    //     nominal type at swift-posix; calls to `ISO_9945.Kernel.Termios.Attributes.get(...)`
    //     resolve unambiguously to L2 (different nominal type).
    //   - The `get(_:)` method is preserved here for API surface consistency
    //     (so consumers can use a single namespace path for all termios ops via
    //     `Kernel.Termios.Attributes.X`), mirroring the Memory.Map gratuitous-
    //     delegation precedent.

    extension POSIX.Kernel {
        /// Policy-aware POSIX termios (terminal attribute) operations.
        public enum Termios: Sendable {}
    }

    extension POSIX.Kernel.Termios {
        /// Terminal attributes — namespace enum hosting L3-policy methods.
        public enum Attributes {}
    }

    extension POSIX.Kernel.Termios.Attributes {
        /// Opaque storage for the underlying termios structure (typealias).
        public typealias Storage = ISO_9945.Kernel.Termios.Attributes.Storage

        /// When to apply terminal attribute changes (typealias).
        public typealias Action = ISO_9945.Kernel.Termios.Attributes.Action
    }

    // MARK: - Termios Attributes Get

    extension POSIX.Kernel.Termios.Attributes {
        /// Get terminal attributes for the given descriptor.
        ///
        /// L3-policy wrapper composing the L2 raw `tcgetattr(fd, &t)` SPI
        /// (`@_spi(Syscall) ISO_9945.Kernel.Termios.Attributes.get(fd:)`) with
        /// typed-descriptor unwrap. Per [PLAT-ARCH-005] / Path X Phase 1
        /// prerequisite: L2 takes raw `Int32`; the typed-descriptor convenience
        /// lives here at L3-policy.
        ///
        /// - Parameter descriptor: The descriptor (must refer to a terminal).
        /// - Returns: Current terminal attributes.
        /// - Throws: ``Error_Primitives.Error`` if the syscall fails.
        public static func get(_ descriptor: borrowing POSIX.Kernel.Descriptor) throws(Error_Primitives.Error) -> ISO_9945.Kernel.Termios.Attributes {
            try ISO_9945.Kernel.Termios.Attributes.get(descriptor)
        }
    }

#endif
