public import ISO_9945_Kernel_Memory

extension POSIX.Kernel.Memory.Map {

    @unsafe
    public static func advise(
        addr: UnsafeMutableRawPointer,
        length: Memory.Address.Count,
        advice: Memory.Map.Advice
    ) {
        unsafe Memory.Map.advise(addr: addr, length: length, advice: advice)
    }

    @unsafe
    public static func advise(
        addr: UnsafeRawPointer,
        length: Memory.Address.Count,
        advice: Memory.Map.Advice
    ) {
        unsafe Memory.Map.advise(addr: addr, length: length, advice: advice)
    }
}
