public import ISO_9945_Kernel_Identity

extension POSIX.Kernel.User {

    public enum Database: Sendable {}
}

extension POSIX.Kernel.User.Database {

    public typealias Entry = ISO_9945.Kernel.User.Database.Entry
}

extension POSIX.Kernel.User.Database {

    @inlinable
    public static func find(
        name: String
    ) throws(ISO_9945.Kernel.User.Database.Error) -> ISO_9945.Kernel.User.Database.Entry? {
        try ISO_9945.Kernel.User.Database.find(name: name)
    }

    @inlinable
    public static func find(
        uid: ISO_9945.Kernel.User.ID
    ) throws(ISO_9945.Kernel.User.Database.Error) -> ISO_9945.Kernel.User.Database.Entry? {
        try ISO_9945.Kernel.User.Database.find(uid: uid)
    }
}
