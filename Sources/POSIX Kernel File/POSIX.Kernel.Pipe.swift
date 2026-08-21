public import ISO_9945_Kernel_File

extension POSIX.Kernel {

    public enum Pipe {}
}

extension POSIX.Kernel.Pipe {

    public typealias Descriptors = ISO_9945.Kernel.Pipe.Descriptors

    public typealias Error = ISO_9945.Kernel.Pipe.Error
}

extension POSIX.Kernel.Pipe {

    @inlinable
    public static func pipe() throws(ISO_9945.Kernel.Pipe.Error) -> ISO_9945.Kernel.Pipe.Descriptors
    {
        while true {
            do throws(ISO_9945.Kernel.Pipe.Error) {
                return try ISO_9945.Kernel.Pipe.pipe()
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }
}
