public import ISO_9945_Kernel_Identity

extension POSIX.Kernel.Group {

    public enum Supplementary: Sendable {}
}

extension POSIX.Kernel.Group.Supplementary {

    @inlinable
    public static func get() throws(Error_Primitives.Error) -> [ISO_9945.Kernel.Group.ID] {
        try ISO_9945.Kernel.Group.Supplementary.get()
    }
}
