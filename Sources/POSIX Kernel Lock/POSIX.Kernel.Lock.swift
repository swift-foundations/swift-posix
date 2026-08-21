@_spi(Syscall) public import ISO_9945_Kernel_Lock
@_spi(Syscall) public import POSIX_Kernel_Descriptor

extension POSIX.Kernel {

    public enum Lock: Sendable {}
}

extension POSIX.Kernel.Lock {

    public typealias Error = ISO_9945.Kernel.Lock.Error

    public typealias Range = ISO_9945.Kernel.Lock.Range

    public typealias Kind = ISO_9945.Kernel.Lock.Kind

    public typealias Acquire = ISO_9945.Kernel.Lock.Acquire

    public typealias Token = ISO_9945.Kernel.Lock.Token

    public typealias Scope = ISO_9945.Kernel.Lock.Scope

    public enum Immediate: Sendable {}
}

extension POSIX.Kernel.Lock {

    public static func lock(
        _ descriptor: borrowing POSIX.Kernel.Descriptor,
        range: Range,
        kind: Kind
    ) throws(Error) {
        try ISO_9945.Kernel.Lock.lock(descriptor, range: range, kind: kind)
    }

    public static func unlock(
        _ descriptor: borrowing POSIX.Kernel.Descriptor,
        range: Range
    ) throws(Error) {
        try ISO_9945.Kernel.Lock.unlock(descriptor, range: range)
    }
}

extension POSIX.Kernel.Lock.Immediate {

    public static func lock(
        _ descriptor: borrowing POSIX.Kernel.Descriptor,
        range: POSIX.Kernel.Lock.Range,
        kind: POSIX.Kernel.Lock.Kind
    ) throws(POSIX.Kernel.Lock.Error) {
        try ISO_9945.Kernel.Lock.Immediate.lock(descriptor, range: range, kind: kind)
    }
}
