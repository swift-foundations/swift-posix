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

@_spi(Syscall) public import ISO_9945_Kernel_Poll
@_spi(Syscall) public import ISO_9945_Kernel_Socket

// MARK: - EINTR-Safe Connect Operation

/// POSIX socket connect with automatic EINTR completion.
///
/// Unlike read/write/accept, connect EINTR does NOT mean "retry the call."
/// When `connect()` returns EINTR, the connection attempt continues
/// asynchronously. This wrapper detects EINTR and uses poll-based
/// completion (`poll(POLLOUT)` + `getsockopt(SO_ERROR)`) to await
/// the result.
///
/// ## When to Use
///
/// Use this wrapper when you want automatic EINTR handling for blocking
/// connects. Use the raw `ISO_9945.Kernel.Socket.Connect` when you need to handle
/// EINTR explicitly or manage non-blocking connect yourself.
///
/// ## Example
///
/// ```swift
/// // Policy-aware (handles EINTR via poll):
/// try POSIX.Kernel.Socket.Connect.connect(socketFd, address: addr)
///
/// // Raw syscall (can throw on EINTR):
/// try ISO_9945.Kernel.Socket.Connect.connect(socketFd, address: addr)
/// ```
extension POSIX.Kernel.Socket {
    /// Connect operations with EINTR completion policy.
    public enum Connect {}
}

// MARK: - Await Completion (poll-based, L3 policy)
//
// Relocated from swift-iso-9945's `ISO 9945.Kernel.Socket.Connect.swift`
// per [PLAT-ARCH-008e]: poll orchestration + EINTR retry is L3 policy,
// not L2 spec-literal, so its canonical home is swift-posix.

extension POSIX.Kernel.Socket.Connect {
    /// Waits for an in-progress connection to complete via poll + SO_ERROR.
    ///
    /// Called after `connect()` returns EINTR or EINPROGRESS. Blocks until
    /// the connection completes or fails.
    ///
    /// Per POSIX: when `connect()` is interrupted, the connection attempt
    /// continues asynchronously. Recovery requires polling for writability,
    /// then checking the socket error to determine the outcome.
    ///
    /// - Parameter descriptor: The socket descriptor with in-progress connection.
    /// - Throws: `ISO_9945.Kernel.Socket.Error` if the connection failed.
    public static func awaitCompletion(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor
    ) throws(ISO_9945.Kernel.Socket.Error) {
        var entries = [ISO_9945.Kernel.Poll.Entry(descriptor, requested: .output)]

        while true {
            do throws(Error_Primitives.Error) {
                let ready = try ISO_9945.Kernel.Poll.poll(&entries, timeout: -1)
                if ready > 0 { break }
            } catch  where error.code.isInterrupted {
                continue
            } catch {
                throw .platform(error)
            }
        }

        let code = try ISO_9945.Kernel.Socket.getError(descriptor)
        guard code == .posix(0) else {
            throw .platform(Error_Primitives.Error(code: code))
        }
    }
}

// MARK: - EINTR-Safe Connect

extension POSIX.Kernel.Socket.Connect {
    /// Connects a socket, awaiting completion if interrupted by a signal.
    ///
    /// - Parameters:
    ///   - descriptor: The socket descriptor.
    ///   - address: The peer address, as a `Storage` container.
    ///   - length: The size of the actual address within storage.
    /// - Throws: ``Kernel/Socket/Error`` on failure (excluding EINTR).
    public static func connect(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        address: ISO_9945.Kernel.Socket.Address.Storage,
        length: ISO_9945.Kernel.Socket.Address.Length
    ) throws(ISO_9945.Kernel.Socket.Error) {
        do throws(ISO_9945.Kernel.Socket.Error) {
            try ISO_9945.Kernel.Socket.Connect.connect(descriptor, address: address, length: length)
        } catch  where error.code.isInterrupted {
            try awaitCompletion(descriptor)
        }
    }

    /// Connects a socket to an IPv4 address, awaiting completion if interrupted.
    public static func connect(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        address: ISO_9945.Kernel.Socket.Address.IPv4
    ) throws(ISO_9945.Kernel.Socket.Error) {
        do throws(ISO_9945.Kernel.Socket.Error) {
            try ISO_9945.Kernel.Socket.Connect.connect(descriptor, address: address)
        } catch  where error.code.isInterrupted {
            try awaitCompletion(descriptor)
        }
    }

    /// Connects a socket to an IPv6 address, awaiting completion if interrupted.
    public static func connect(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        address: ISO_9945.Kernel.Socket.Address.IPv6
    ) throws(ISO_9945.Kernel.Socket.Error) {
        do throws(ISO_9945.Kernel.Socket.Error) {
            try ISO_9945.Kernel.Socket.Connect.connect(descriptor, address: address)
        } catch  where error.code.isInterrupted {
            try awaitCompletion(descriptor)
        }
    }

    /// Connects a socket to a Unix domain address, awaiting completion if interrupted.
    public static func connect(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        address: ISO_9945.Kernel.Socket.Address.Unix
    ) throws(ISO_9945.Kernel.Socket.Error) {
        do throws(ISO_9945.Kernel.Socket.Error) {
            try ISO_9945.Kernel.Socket.Connect.connect(descriptor, address: address)
        } catch  where error.code.isInterrupted {
            try awaitCompletion(descriptor)
        }
    }
}
