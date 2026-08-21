public import ISO_9945_Kernel_Thread

extension POSIX.Kernel.Thread {

    @inlinable
    public static func create(
        _ body: @escaping @Sendable () -> Void
    ) throws(ISO_9945.Kernel.Thread.Error) -> ISO_9945.Kernel.Thread.Handle {
        try ISO_9945.Kernel.Thread.create(body)
    }
}
