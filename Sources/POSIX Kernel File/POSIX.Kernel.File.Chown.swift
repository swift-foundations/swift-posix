public import ISO_9945_Kernel_File

extension POSIX.Kernel.File {

    public enum Chown {}
}

extension POSIX.Kernel.File.Chown {

    public typealias Error = ISO_9945.Kernel.File.Chown.Error
}

extension POSIX.Kernel.File.Chown {

    @inlinable
    public static func chown(
        path: borrowing Path.Borrowed,
        uid: ISO_9945.Kernel.User.ID,
        gid: ISO_9945.Kernel.Group.ID
    ) throws(ISO_9945.Kernel.File.Chown.Error) {
        try ISO_9945.Kernel.File.Chown.chown(path: path, uid: uid, gid: gid)
    }

    @inlinable
    public static func lchown(
        path: borrowing Path.Borrowed,
        uid: ISO_9945.Kernel.User.ID,
        gid: ISO_9945.Kernel.Group.ID
    ) throws(ISO_9945.Kernel.File.Chown.Error) {
        try ISO_9945.Kernel.File.Chown.lchown(path: path, uid: uid, gid: gid)
    }

    @inlinable
    public static func fchown(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        uid: ISO_9945.Kernel.User.ID,
        gid: ISO_9945.Kernel.Group.ID
    ) throws(ISO_9945.Kernel.File.Chown.Error) {
        try ISO_9945.Kernel.File.Chown.fchown(descriptor, uid: uid, gid: gid)
    }
}
