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

// MARK: - EINTR-Safe Send Operations

/// POSIX socket send with automatic EINTR retry.
///
/// These are the policy-aware wrappers around the raw POSIX send syscalls
/// in `ISO_9945.Kernel.Socket.Send`. They automatically retry on EINTR (signal
/// interruption).
///
/// ## When to Use
///
/// Use these wrappers when you want the standard "retry on EINTR" behavior.
/// Use the raw `ISO_9945.Kernel.Socket.Send` when you need to handle EINTR
/// explicitly, such as for graceful shutdown via signal.
extension POSIX.Kernel.Socket {
    /// Send operations with EINTR retry policy.
    public enum Send {}
}

extension POSIX.Kernel.Socket.Send {
    /// Sends data from a span on a connected socket, automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The socket descriptor (must be connected).
    ///   - span: The data to send.
    ///   - options: Message flags (default: none).
    /// - Returns: The number of bytes actually sent.
    /// - Throws: ``Kernel/Socket/Error`` on failure (excluding EINTR).
    public static func send(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        from span: Swift.Span<Byte>,
        options: ISO_9945.Kernel.Socket.Message.Options = []
    ) throws(ISO_9945.Kernel.Socket.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Send.send(
                    descriptor,
                    from: span,
                    options: options
                )
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    /// Sends data from a span to a specific address, automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The socket descriptor.
    ///   - span: The data to send.
    ///   - options: Message flags (default: none).
    ///   - address: The destination address.
    ///   - addressLength: The size of the destination address.
    /// - Returns: The number of bytes actually sent.
    /// - Throws: ``Kernel/Socket/Error`` on failure (excluding EINTR).
    public static func to(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        from span: Swift.Span<Byte>,
        options: ISO_9945.Kernel.Socket.Message.Options = [],
        address: ISO_9945.Kernel.Socket.Address.Storage,
        addressLength: ISO_9945.Kernel.Socket.Address.Length
    ) throws(ISO_9945.Kernel.Socket.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Send.to(
                    descriptor,
                    from: span,
                    options: options,
                    address: address,
                    addressLength: addressLength
                )
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    /// Sends a message with full control over headers and ancillary data,
    /// automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The socket descriptor.
    ///   - header: The message header describing buffers, address, and control data.
    ///   - options: Message flags (default: none).
    /// - Returns: The number of bytes actually sent.
    /// - Throws: ``Kernel/Socket/Error`` on failure (excluding EINTR).
    public static func message(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        header: inout ISO_9945.Kernel.Socket.Message.Header,
        options: ISO_9945.Kernel.Socket.Message.Options = []
    ) throws(ISO_9945.Kernel.Socket.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Send.message(
                    descriptor,
                    header: &header,
                    options: options
                )
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }
}
