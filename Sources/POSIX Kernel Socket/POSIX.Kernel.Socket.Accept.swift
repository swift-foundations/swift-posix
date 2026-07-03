// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-posix open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-posix project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import ISO_9945_Kernel_Socket

// MARK: - EINTR-Safe Accept Operation

/// POSIX socket accept with automatic EINTR retry.
///
/// This is the policy-aware wrapper around the raw POSIX `accept(2)` syscall
/// in `ISO_9945.Kernel.Socket.Accept`. It automatically retries on EINTR (signal
/// interruption), which is the expected behavior for most server applications.
///
/// ## When to Use
///
/// Use this wrapper when you want the standard "retry on EINTR" behavior.
/// Use the raw `ISO_9945.Kernel.Socket.Accept` when you need to handle EINTR
/// explicitly (e.g., for graceful shutdown via signal).
///
/// ## Example
///
/// ```swift
/// // Policy-aware (retries on EINTR):
/// let result = try POSIX.Kernel.Socket.Accept.accept(listenFd)
///
/// // Raw syscall (can throw on EINTR):
/// let result = try ISO_9945.Kernel.Socket.Accept.accept(listenFd)
/// ```
extension POSIX.Kernel {
    /// Socket operations namespace.
    public enum Socket {
        /// Accept operations with EINTR retry policy.
        public enum Accept {}
    }
}

extension POSIX.Kernel.Socket.Accept {
    /// Accepts an incoming connection, automatically retrying on EINTR.
    ///
    /// - Parameter descriptor: The listening socket descriptor.
    /// - Returns: A result containing the new connected descriptor and peer address.
    /// - Throws: ``Kernel/Socket/Error`` on failure (excluding EINTR).
    public static func accept(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor
    ) throws(ISO_9945.Kernel.Socket.Error) -> ISO_9945.Kernel.Socket.Accept.Result {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Accept.accept(descriptor)
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

}
