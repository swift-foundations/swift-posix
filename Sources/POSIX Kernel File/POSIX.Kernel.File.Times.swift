public import ISO_9945_Kernel_File

extension POSIX.Kernel.File {

    public enum Times {}
}

extension POSIX.Kernel.File.Times {

    public typealias Error = ISO_9945.Kernel.File.Times.Error
}

extension POSIX.Kernel.File.Times {

    @inlinable
    public static func set(
        access accessTime: ISO_9945.Kernel.Time,
        modification modificationTime: ISO_9945.Kernel.Time,
        at path: borrowing Path.Borrowed,
        followSymlinks: Bool = true
    ) throws(ISO_9945.Kernel.File.Times.Error) {
        try ISO_9945.Kernel.File.Times.set(
            access: accessTime,
            modification: modificationTime,
            at: path,
            followSymlinks: followSymlinks
        )
    }

    @inlinable
    public static func set(
        access accessTime: ISO_9945.Kernel.Time,
        modification modificationTime: ISO_9945.Kernel.Time,
        on descriptor: borrowing ISO_9945.Kernel.Descriptor
    ) throws(ISO_9945.Kernel.File.Times.Error) {
        try ISO_9945.Kernel.File.Times.set(
            access: accessTime,
            modification: modificationTime,
            on: descriptor
        )
    }
}
