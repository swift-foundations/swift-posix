public import ISO_9945_Kernel_File

extension POSIX.Kernel.File {

    public enum Control {}
}

extension POSIX.Kernel.File.Control {

    public typealias Error = ISO_9945.Kernel.File.Control.Error
}

extension POSIX.Kernel.File.Control {

    @inlinable
    public static func setNonBlocking(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor
    ) throws(ISO_9945.Kernel.File.Control.Error) {
        try ISO_9945.Kernel.File.Control.setNonBlocking(descriptor)
    }

    @inlinable
    public static func setBlocking(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor
    ) throws(ISO_9945.Kernel.File.Control.Error) {
        try ISO_9945.Kernel.File.Control.setBlocking(descriptor)
    }
}
