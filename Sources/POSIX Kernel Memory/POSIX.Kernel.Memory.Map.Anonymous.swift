public import ISO_9945_Kernel_Memory

extension POSIX.Kernel.Memory.Map {

    public enum Anonymous {}
}

extension POSIX.Kernel.Memory.Map.Anonymous {

    public static func map(
        length: Memory.Address.Count,
        protection: Memory.Map.Protection = [.read, .write],
        shared: Bool = false
    ) throws(Memory.Map.Error) -> Memory.Map.Region {
        try Memory.Map.Anonymous.map(length: length, protection: protection, shared: shared)
    }
}
