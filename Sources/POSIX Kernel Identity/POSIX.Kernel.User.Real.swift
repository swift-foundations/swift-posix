public import ISO_9945_Kernel_Identity

extension POSIX.Kernel.User {

    public enum Real: Sendable {}
}

extension POSIX.Kernel.User.Real {

    @inlinable
    public static func id() -> ISO_9945.Kernel.User.ID {
        ISO_9945.Kernel.User.Real.id()
    }

    @inlinable
    public static func set(_ uid: ISO_9945.Kernel.User.ID) throws(Error_Primitives.Error) {
        try ISO_9945.Kernel.User.Real.set(uid)
    }
}
