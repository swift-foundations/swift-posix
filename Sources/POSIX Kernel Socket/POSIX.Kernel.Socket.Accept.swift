public import ISO_9945_Kernel_Socket

extension POSIX.Kernel {

    public enum Socket {}
}

extension POSIX.Kernel.Socket {

    public enum Accept {}
}

extension POSIX.Kernel.Socket.Accept {

    public static func accept(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor
    ) throws(ISO_9945.Kernel.Socket.Error) -> ISO_9945.Kernel.Socket.Accept.Result {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Accept.accept(descriptor)
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

}
