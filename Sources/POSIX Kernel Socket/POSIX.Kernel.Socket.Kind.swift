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

public import ISO_9945_Kernel_Socket

extension POSIX.Kernel.Socket {
    /// Kind — L3-policy typealias to the L2-canonical iso-9945 form.
    ///
    /// Per [PLAT-ARCH-005] revised / [PLAT-ARCH-008e] (Wave 3.5 POSIX
    /// wrapping): POSIX-shared socket vocabulary is canonical at L2
    /// (`ISO_9945.Kernel.Socket.Kind`); swift-posix contributes the
    /// L3-policy typealias so the three-tier chain
    /// `Kernel.Socket.Kind → POSIX.Kernel.Socket.Kind →
    /// ISO_9945.Kernel.Socket.Kind` composes one tier at a time.
    /// No EINTR policy applies to this name — the typed Phase-1.5 form
    /// passes through unwrapped (unlike Accept / Connect / Receive /
    /// Send, which carry policy method-wrappers).
    public typealias Kind = ISO_9945.Kernel.Socket.Kind
}
