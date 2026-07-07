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

// MARK: - EINTR-Safe Receive Operations

/// POSIX socket receive with automatic EINTR retry.
///
/// These are the policy-aware wrappers around the raw POSIX recv syscalls
/// in `ISO_9945.Kernel.Socket.Receive`. They automatically retry on EINTR (signal
/// interruption).
///
/// ## When to Use
///
/// Use these wrappers when you want the standard "retry on EINTR" behavior.
/// Use the raw `ISO_9945.Kernel.Socket.Receive` when you need to handle EINTR
/// explicitly, such as for graceful shutdown via signal.
extension POSIX.Kernel.Socket {
    /// Receive operations with EINTR retry policy.
    public enum Receive {}
}

extension POSIX.Kernel.Socket.Receive {
    /// Receives data from a connected socket into a mutable span,
    /// automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The socket descriptor (must be connected).
    ///   - span: The mutable span to receive into.
    ///   - options: Message flags (default: none).
    /// - Returns: The number of bytes received, or 0 for EOF.
    /// - Throws: ``Kernel/Socket/Error`` on failure (excluding EINTR).
    public static func receive(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        into span: inout MutableSpan<Byte>,
        options: ISO_9945.Kernel.Socket.Message.Options = []
    ) throws(ISO_9945.Kernel.Socket.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Receive.receive(descriptor, into: &span, options: options)
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    /// Receives data and the sender's address into a mutable span,
    /// automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The socket descriptor.
    ///   - span: The mutable span to receive into.
    ///   - options: Message flags (default: none).
    /// - Returns: The number of bytes received, the sender's address, and address length.
    /// - Throws: ``Kernel/Socket/Error`` on failure (excluding EINTR).
    public static func from(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        into span: inout MutableSpan<Byte>,
        options: ISO_9945.Kernel.Socket.Message.Options = []
    ) throws(ISO_9945.Kernel.Socket.Error) -> (count: Int, address: ISO_9945.Kernel.Socket.Address.Storage, addressLength: ISO_9945.Kernel.Socket.Address.Length) {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Receive.from(descriptor, into: &span, options: options)
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    /// Receives a message with full control over headers and ancillary data,
    /// automatically retrying on EINTR.
    ///
    /// - Parameters:
    ///   - descriptor: The socket descriptor.
    ///   - header: The message header describing receive buffers and control data.
    ///   - options: Message flags (default: none).
    /// - Returns: The number of bytes received.
    /// - Throws: ``Kernel/Socket/Error`` on failure (excluding EINTR).
    public static func message(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        header: inout ISO_9945.Kernel.Socket.Message.Header,
        options: ISO_9945.Kernel.Socket.Message.Options = []
    ) throws(ISO_9945.Kernel.Socket.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Receive.message(descriptor, header: &header, options: options)
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }
}
