public import ISO_9945_Kernel_Process

extension POSIX.Kernel.Process {

    public enum Kill: Sendable {}
}

extension POSIX.Kernel.Process.Kill {

    @inlinable
    public static func kill(
        _ process: ISO_9945.Kernel.Process.ID,
        _ signal: ISO_9945.Kernel.Signal.Number
    ) throws(ISO_9945.Kernel.Process.Error) {
        try ISO_9945.Kernel.Process.Kill.kill(process, signal)
    }
}
