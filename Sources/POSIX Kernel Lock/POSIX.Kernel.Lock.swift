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

@_spi(Syscall) public import ISO_9945_Kernel_Lock
@_spi(Syscall) public import POSIX_Kernel_Descriptor

extension POSIX.Kernel {
    /// Policy-aware POSIX file-locking operations.
    ///
    /// L3-policy throwing wrappers composing the iso-9945 raw `fcntl` SPI
    /// forms per [PLAT-ARCH-008e] (L3-unifier composes L3-policy) and
    /// [PLAT-ARCH-005] revised (descriptor type lives at L3-policy).
    public enum Lock: Sendable {
        /// Errors thrown by file-locking operations.
        public typealias Error = ISO_9945.Kernel.Lock.Error

        /// Range descriptor for a lock.
        public typealias Range = ISO_9945.Kernel.Lock.Range

        /// Lock kind (shared or exclusive).
        public typealias Kind = ISO_9945.Kernel.Lock.Kind

        /// Lock acquisition mode (Wave 3.5-Final-Atomic gap-fill 2026-05-02).
        public typealias Acquire = ISO_9945.Kernel.Lock.Acquire

        /// Lock token (~Copyable RAII handle; Wave 3.5-Final-Atomic gap-fill 2026-05-02).
        public typealias Token = ISO_9945.Kernel.Lock.Token

        /// Lock scope namespace (Wave 3.5-Final-Atomic gap-fill 2026-05-02).
        public typealias Scope = ISO_9945.Kernel.Lock.Scope

        /// Non-blocking lock operations.
        public enum Immediate: Sendable {}
    }
}

// MARK: - Blocking lock / unlock

extension POSIX.Kernel.Lock {
    /// Acquires a lock on a byte range (blocking).
    ///
    /// L3-policy wrapper composing the L2 typed `fcntl(fd, F_SETLKW, ...)`
    /// form (`ISO_9945.Kernel.Lock.lock(_:range:kind:)`) with the
    /// `POSIX.Kernel.Descriptor` policy typealias. Error type is the L2 error;
    /// future policy refinements (e.g., normalized error mapping) live here.
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor.
    ///   - range: The byte range to lock.
    ///   - kind: The lock kind (shared or exclusive).
    /// - Throws: ``Error/deadlock`` if a deadlock is detected,
    ///           ``Error/unavailable`` if the system lock table is exhausted.
    public static func lock(
        _ descriptor: borrowing POSIX.Kernel.Descriptor,
        range: Range,
        kind: Kind
    ) throws(Error) {
        try ISO_9945.Kernel.Lock.lock(descriptor, range: range, kind: kind)
    }

    /// Releases a lock on a byte range.
    ///
    /// L3-policy wrapper composing the L2 typed `fcntl(fd, F_SETLK, ...)`
    /// (`F_UNLCK`) form (`ISO_9945.Kernel.Lock.unlock(_:range:)`).
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor.
    ///   - range: The byte range to unlock.
    /// - Throws: ``Error`` if unlocking fails.
    public static func unlock(
        _ descriptor: borrowing POSIX.Kernel.Descriptor,
        range: Range
    ) throws(Error) {
        try ISO_9945.Kernel.Lock.unlock(descriptor, range: range)
    }
}

// MARK: - Non-blocking lock (Immediate)

extension POSIX.Kernel.Lock.Immediate {
    /// Attempts to acquire a lock without blocking.
    ///
    /// L3-policy wrapper composing the L2 typed `fcntl(fd, F_SETLK, ...)`
    /// form (`ISO_9945.Kernel.Lock.Immediate.lock(_:range:kind:)`).
    ///
    /// - Parameters:
    ///   - descriptor: The file descriptor.
    ///   - range: The byte range to lock.
    ///   - kind: The lock kind (shared or exclusive).
    /// - Throws: ``POSIX/Kernel/Lock/Error/contention`` if the lock is held
    ///           by another process, ``POSIX/Kernel/Lock/Error/deadlock`` if a
    ///           deadlock is detected, ``POSIX/Kernel/Lock/Error/unavailable``
    ///           if the system lock table is exhausted.
    public static func lock(
        _ descriptor: borrowing POSIX.Kernel.Descriptor,
        range: POSIX.Kernel.Lock.Range,
        kind: POSIX.Kernel.Lock.Kind
    ) throws(POSIX.Kernel.Lock.Error) {
        try ISO_9945.Kernel.Lock.Immediate.lock(descriptor, range: range, kind: kind)
    }
}
