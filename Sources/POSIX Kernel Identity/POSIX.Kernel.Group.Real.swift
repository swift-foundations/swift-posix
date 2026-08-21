public import ISO_9945_Kernel_Identity

extension POSIX.Kernel.Group {

    public enum Real: Sendable {}
}

extension POSIX.Kernel.Group.Real {

    @inlinable
    public static func id() -> ISO_9945.Kernel.Group.ID {
        ISO_9945.Kernel.Group.Real.id()
    }

    @inlinable
    public static func set(_ gid: ISO_9945.Kernel.Group.ID) throws(Error_Primitives.Error) {
        try ISO_9945.Kernel.Group.Real.set(gid)
    }
}
