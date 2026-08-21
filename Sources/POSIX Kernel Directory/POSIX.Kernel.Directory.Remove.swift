public import ISO_9945_Kernel_Directory

extension POSIX.Kernel.Directory {

    public enum Remove: Sendable {}
}

extension POSIX.Kernel.Directory.Remove {

    public typealias Error = ISO_9945.Kernel.Directory.Remove.Error
}

extension POSIX.Kernel.Directory.Remove {

    @inlinable
    public static func remove(
        _ path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.Directory.Remove.Error) {
        try ISO_9945.Kernel.Directory.Remove.remove(path)
    }
}
