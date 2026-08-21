public import ISO_9945_Kernel_Identity

extension POSIX.Kernel.Group {

    public enum Database: Sendable {}
}

extension POSIX.Kernel.Group.Database {

    public typealias Entry = ISO_9945.Kernel.Group.Database.Entry
}

extension POSIX.Kernel.Group.Database {

    @inlinable
    public static func find(
        name: String
    ) throws(ISO_9945.Kernel.Group.Database.Error) -> ISO_9945.Kernel.Group.Database.Entry? {
        try ISO_9945.Kernel.Group.Database.find(name: name)
    }

    @inlinable
    public static func find(
        gid: ISO_9945.Kernel.Group.ID
    ) throws(ISO_9945.Kernel.Group.Database.Error) -> ISO_9945.Kernel.Group.Database.Entry? {
        try ISO_9945.Kernel.Group.Database.find(gid: gid)
    }
}
