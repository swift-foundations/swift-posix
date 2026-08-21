public import ISO_9945_Kernel_File

extension POSIX.Kernel.File {

    public enum Delete {}
}

extension POSIX.Kernel.File.Delete {

    public typealias Error = ISO_9945.Kernel.File.Delete.Error
}

extension POSIX.Kernel.File.Delete {

    @inlinable
    public static func delete(
        _ path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.File.Delete.Error) {
        try ISO_9945.Kernel.File.Delete.delete(path)
    }
}
