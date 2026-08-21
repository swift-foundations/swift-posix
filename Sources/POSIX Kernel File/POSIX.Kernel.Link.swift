public import ISO_9945_Kernel_File

extension POSIX.Kernel {

    public enum Link {}
}

extension POSIX.Kernel.Link {

    public typealias Error = ISO_9945.Kernel.Link.Error
}

extension POSIX.Kernel.Link {

    @inlinable
    public static func create(
        at linkPath: borrowing Path.Borrowed,
        to existingPath: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.Link.Error) {
        try ISO_9945.Kernel.Link.create(at: linkPath, to: existingPath)
    }
}
