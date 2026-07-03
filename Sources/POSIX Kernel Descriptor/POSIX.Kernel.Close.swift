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

public import ISO_9945_Core

extension POSIX.Kernel {
    /// Policy-aware POSIX descriptor close.
    ///
    /// L3-policy throwing wrapper composing the L2 typed close syscall
    /// (`ISO_9945.Kernel.Close.close(_:consuming Descriptor)`). After Wave 4c-Socket
    /// Prerequisite (2026-05-01) collapsed `POSIX.Kernel.Descriptor` to a typealias
    /// of `ISO_9945.Kernel.Descriptor`, the round-trip pattern (extract Int32 →
    /// reconstruct L2 Descriptor) is eliminated; this wrapper passes the typed
    /// Descriptor directly to the L2 typed close.
    ///
    /// ## Ownership
    ///
    /// ``close(_:)`` consumes the descriptor. After the call, the descriptor
    /// is gone. If `close(_:)` is not called explicitly, the descriptor's
    /// `deinit` closes the fd automatically (best-effort, errors swallowed).
    public enum Close: Sendable {}
}

// MARK: - Close

extension POSIX.Kernel.Close {
    /// Close a POSIX file descriptor, reporting errors.
    ///
    /// Consumes the descriptor and delegates to the L2 typed close form,
    /// remapping `ISO_9945.Kernel.Close.Error` to `POSIX.Kernel.Close.Error`
    /// case-by-case. The L2 form handles disarming + libc call + errno
    /// mapping internally; this L3 wrapper preserves the L3-policy error
    /// type for source compatibility.
    ///
    /// - Parameter descriptor: The file descriptor to close (consumed).
    /// - Throws: ``Error`` on failure.
    public static func close(_ descriptor: consuming POSIX.Kernel.Descriptor) throws(Error) {
        do throws(ISO_9945.Kernel.Close.Error) {
            try ISO_9945.Kernel.Close.close(descriptor)
        } catch {
            switch error {
            case .handle(let e):
                throw .handle(e)

            case .platform(let e):
                throw .platform(e)
            }
        }
    }
}
