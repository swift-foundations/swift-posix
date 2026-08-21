public import ISO_9945_Kernel_Thread

extension POSIX.Kernel.Thread {

    @inlinable
    public static func yield() {
        ISO_9945.Kernel.Thread.yield()
    }
}
