public import ISO_9945_Kernel_File

extension POSIX.Kernel.File {

    public enum Truncate {}
}

extension POSIX.Kernel.File.Truncate {

    @inlinable
    public static func truncate(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        to length: ISO_9945.Kernel.File.Size
    ) throws(Error_Primitives.Error) {
        while true {
            do throws(Error_Primitives.Error) {
                try ISO_9945.Kernel.File.Truncate.truncate(descriptor, to: length)
                return
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    @inlinable
    public static func truncate(
        path: UnsafePointer<CChar>,
        to length: ISO_9945.Kernel.File.Size
    ) throws(Error_Primitives.Error) {
        while true {
            do throws(Error_Primitives.Error) {
                try unsafe ISO_9945.Kernel.File.Truncate.truncate(path: path, to: length)
                return
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }
}
