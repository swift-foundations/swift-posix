public import ISO_9945_Kernel_Process

extension POSIX.Kernel.Process {

    public enum Exit: Sendable {}
}

extension POSIX.Kernel.Process.Exit {

    @inlinable
    public static func now(_ status: Int32) -> Never {
        ISO_9945.Kernel.Process.Exit.now(status)
    }

    @inlinable
    public static func normal(_ status: Int32) -> Never {
        ISO_9945.Kernel.Process.Exit.normal(status)
    }
}
