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

extension POSIX.Kernel.Descriptor {
    /// Readiness categories a caller wants to be notified about for a
    /// descriptor.
    ///
    /// Cross-paradigm vocabulary — shared by reactor-style readiness
    /// (``Kernel/Event``) and proactor-style completion polling
    /// (``Kernel/Completion``). The concept ("what aspects of this
    /// descriptor's readiness am I interested in?") is unitary across
    /// platforms; the encoding into platform-specific masks/filters
    /// happens at the spec layer (L2) via per-platform projection
    /// initializers.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Monitor for both read and write readiness.
    /// let interest: POSIX.Kernel.Descriptor.Interest = [.read, .write]
    ///
    /// if interest.contains(.read) {
    ///     // Will be notified when data is available
    /// }
    /// ```
    ///
    /// ## Platform Mapping
    ///
    /// | Interest     | POSIX poll    | Linux epoll | Linux io_uring POLL | Darwin kqueue (expansion) |
    /// |--------------|---------------|-------------|----------------------|---------------------------|
    /// | `.read`      | `POLLIN`      | `EPOLLIN`   | `POLLIN`             | `EVFILT_READ` kevent      |
    /// | `.write`     | `POLLOUT`     | `EPOLLOUT`  | `POLLOUT`            | `EVFILT_WRITE` kevent     |
    /// | `.priority`  | `POLLPRI`     | `EPOLLPRI`  | `POLLPRI`            | `EV_OOBAND` (indirect)    |
    ///
    /// kqueue is the outlier — filters are an enum tag, not a bitmask.
    /// One `Interest` containing both `.read` and `.write` expands to two
    /// separate kevents; platform backends handle this translation.
    public struct Interest: OptionSet, Sendable, Hashable {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
    }
}

extension POSIX.Kernel.Descriptor.Interest {
    /// Interest in read readiness (data available to read).
    public static let read = Self(rawValue: 1 << 0)

    /// Interest in write readiness (buffer space available for writing).
    public static let write = Self(rawValue: 1 << 1)

    /// Interest in priority/out-of-band data (platform-specific).
    ///
    /// On Linux, this maps to `EPOLLPRI` (urgent data).
    /// On Darwin, this is less commonly used.
    public static let priority = Self(rawValue: 1 << 2)
}

// MARK: - CustomStringConvertible

extension POSIX.Kernel.Descriptor.Interest: CustomStringConvertible {
    public var description: Swift.String {
        var parts: [Swift.String] = []
        if contains(.read) { parts.append("read") }
        if contains(.write) { parts.append("write") }
        if contains(.priority) { parts.append("priority") }
        return parts.isEmpty ? "none" : parts.joined(separator: "|")
    }
}
