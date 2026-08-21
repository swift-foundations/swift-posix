public import ISO_9945_Kernel_Signal

extension POSIX.Kernel.Signal {

    public enum Mask: Sendable {}
}

extension POSIX.Kernel.Signal.Mask {

    public typealias How = ISO_9945.Kernel.Signal.Mask.How
}

extension POSIX.Kernel.Signal.Mask {

    @inlinable
    public static func change(
        _ how: ISO_9945.Kernel.Signal.Mask.How,
        signals: ISO_9945.Kernel.Signal.Set
    ) throws(ISO_9945.Kernel.Signal.Error) -> ISO_9945.Kernel.Signal.Set {
        try ISO_9945.Kernel.Signal.Mask.change(how, signals: signals)
    }

    @inlinable
    public static func pending() throws(ISO_9945.Kernel.Signal.Error) -> ISO_9945.Kernel.Signal.Set
    {
        try ISO_9945.Kernel.Signal.Mask.pending()
    }
}
