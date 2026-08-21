public import ISO_9945_Kernel_Memory

extension POSIX.Kernel.Memory {

    public enum Lock: Sendable {}
}

extension POSIX.Kernel.Memory.Lock {

    public typealias Error = Memory.Lock.Error

    public typealias All = Memory.Lock.All
}

extension POSIX.Kernel.Memory.Lock {

    @unsafe
    @inlinable
    public static func lock(
        address: UnsafeRawPointer,
        length: Memory.Address.Count
    ) throws(Memory.Lock.Error) {
        try unsafe Memory.Lock.lock(address: address, length: length)
    }

    @unsafe
    @inlinable
    public static func unlock(
        address: UnsafeRawPointer,
        length: Memory.Address.Count
    ) throws(Memory.Lock.Error) {
        try unsafe Memory.Lock.unlock(address: address, length: length)
    }

    @inlinable
    public static func lockAll(_ flags: Memory.Lock.All.Options) throws(Memory.Lock.Error) {
        try Memory.Lock.lockAll(flags)
    }

    @inlinable
    public static func unlockAll() throws(Memory.Lock.Error) {
        try Memory.Lock.unlockAll()
    }
}
