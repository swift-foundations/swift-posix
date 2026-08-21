public import ISO_9945_Kernel_File

extension POSIX.Kernel.File {

    public enum Flush {}
}

extension POSIX.Kernel.File.Flush {

    public typealias Error = ISO_9945.Kernel.File.Flush.Error
}

extension POSIX.Kernel.File.Flush {

    @inlinable
    public static func flush(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor
    ) throws(ISO_9945.Kernel.File.Flush.Error) {
        while true {
            do throws(ISO_9945.Kernel.File.Flush.Error) {
                try ISO_9945.Kernel.File.Flush.fsync(descriptor)
                return
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }
}
