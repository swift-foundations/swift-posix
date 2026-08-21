public import ISO_9945_Kernel_File

extension POSIX.Kernel.File {

    public enum Attributes {}
}

extension POSIX.Kernel.File.Attributes {

    public typealias Error = ISO_9945.Kernel.File.Attributes.Error
}

extension POSIX.Kernel.File.Attributes {

    @inlinable
    public static func set(
        _ permissions: ISO_9945.Kernel.File.Permissions,
        at path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.File.Attributes.Error) {
        try ISO_9945.Kernel.File.Attributes.set(permissions, at: path)
    }

    @inlinable
    public static func set(
        _ permissions: ISO_9945.Kernel.File.Permissions,
        on descriptor: borrowing ISO_9945.Kernel.Descriptor
    ) throws(ISO_9945.Kernel.File.Attributes.Error) {
        try ISO_9945.Kernel.File.Attributes.set(permissions, on: descriptor)
    }
}
