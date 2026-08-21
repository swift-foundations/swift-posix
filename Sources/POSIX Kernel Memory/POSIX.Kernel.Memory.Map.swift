public import ISO_9945_Kernel_Memory

extension POSIX.Kernel.Memory {

    public enum Map {}
}

extension POSIX.Kernel.Memory.Map {

    public typealias Region = Memory.Map.Region

    public typealias Error = Memory.Map.Error

    public typealias Protection = Memory.Map.Protection

    public typealias Options = Memory.Map.Options

    public typealias Sync = Memory.Map.Sync

    public typealias Advice = Memory.Map.Advice

    public typealias Access = Memory.Map.Access

    public typealias Sharing = Memory.Map.Sharing

    public typealias Safety = Memory.Map.Safety
}

extension POSIX.Kernel.Memory.Map {

    public static func map(
        addr: Memory.Address? = nil,
        length: Memory.Address.Count,
        protection: Memory.Map.Protection,
        flags: Memory.Map.Options,
        descriptor: borrowing ISO_9945.Kernel.Descriptor = .invalid,
        offset: ISO_9945.Kernel.File.Offset = .zero
    ) throws(Memory.Map.Error) -> Memory.Address {
        try Memory.Map.map(
            addr: addr,
            length: length,
            protection: protection,
            flags: flags,
            descriptor: descriptor,
            offset: offset
        )
    }

    public static func unmap(
        addr: Memory.Address,
        length: Memory.Address.Count
    ) throws(Memory.Map.Error) {
        try Memory.Map.unmap(addr: addr, length: length)
    }

    public static func unmap(_ region: Memory.Map.Region) throws(Memory.Map.Error) {
        try Memory.Map.unmap(region)
    }

    public static func sync(
        addr: Memory.Address,
        length: Memory.Address.Count,
        flags: Memory.Map.Sync.Options = .sync
    ) throws(Memory.Map.Error) {
        while true {
            do throws(Memory.Map.Error) {
                try Memory.Map.sync(addr: addr, length: length, flags: flags)
                return
            } catch {
                if case .sync(let code) = error, code.isInterrupted {
                    continue
                }
                throw error
            }
        }
    }

    public static func protect(
        addr: Memory.Address,
        length: Memory.Address.Count,
        protection: Memory.Map.Protection
    ) throws(Memory.Map.Error) {
        try Memory.Map.protect(addr: addr, length: length, protection: protection)
    }

    public static func advise(
        addr: Memory.Address,
        length: Memory.Address.Count,
        advice: Memory.Map.Advice
    ) {
        Memory.Map.advise(addr: addr, length: length, advice: advice)
    }
}
