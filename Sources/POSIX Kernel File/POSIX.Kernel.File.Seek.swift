public import ISO_9945_Kernel_File

extension POSIX.Kernel.File {

    public enum Seek {}
}

extension POSIX.Kernel.File.Seek {

    public typealias Error = ISO_9945.Kernel.File.Seek.Error

    public typealias Whence = ISO_9945.Kernel.File.Seek.Whence
}

extension POSIX.Kernel.File.Seek {

    @discardableResult
    @inlinable
    public static func seek(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        offset: Int64,
        whence: ISO_9945.Kernel.File.Seek.Whence
    ) throws(ISO_9945.Kernel.File.Seek.Error) -> Int64 {
        try ISO_9945.Kernel.File.Seek.seek(descriptor, offset: offset, whence: whence)
    }

    @inlinable
    public static func tell(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor
    ) throws(ISO_9945.Kernel.File.Seek.Error) -> Int64 {
        try ISO_9945.Kernel.File.Seek.tell(descriptor)
    }
}
