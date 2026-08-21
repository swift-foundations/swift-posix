public import ISO_9945_Kernel_Directory

extension POSIX.Kernel.Directory {

    public enum Create: Sendable {}
}

extension POSIX.Kernel.Directory.Create {

    public typealias Error = ISO_9945.Kernel.Directory.Create.Error
}

extension POSIX.Kernel.Directory.Create {

    @inlinable
    public static func create(
        _ path: borrowing Path.Borrowed,
        permissions: ISO_9945.Kernel.File.Permissions = ISO_9945.Kernel.File.Permissions(
            rawValue: 0o755
        )
    ) throws(ISO_9945.Kernel.Directory.Create.Error) {
        try ISO_9945.Kernel.Directory.Create.create(path, permissions: permissions)
    }

    @inlinable
    public static func create(
        _ path: borrowing Path.Borrowed,
        relativeTo descriptor: borrowing ISO_9945.Kernel.Descriptor,
        permissions: ISO_9945.Kernel.File.Permissions = ISO_9945.Kernel.File.Permissions(
            rawValue: 0o755
        )
    ) throws(ISO_9945.Kernel.Directory.Create.Error) {
        try ISO_9945.Kernel.Directory.Create.create(
            path,
            relativeTo: descriptor,
            permissions: permissions
        )
    }
}
