public import ISO_9945_Kernel_Memory

extension POSIX.Kernel.Memory {

    public enum Shared: Sendable {}
}

extension POSIX.Kernel.Memory.Shared {

    public typealias Error = Memory.Shared.Error

    public typealias Access = Memory.Shared.Access

    public typealias Options = Memory.Shared.Options
}

extension POSIX.Kernel.Memory.Shared {

    @unsafe
    @inlinable
    public static func open(
        name: UnsafePointer<CChar>,
        access: Memory.Shared.Access,
        options: Memory.Shared.Options = [],
        permissions: ISO_9945.Kernel.File.Permissions = .ownerReadWrite
    ) throws(Memory.Shared.Error) -> ISO_9945.Kernel.Descriptor {
        try unsafe Memory.Shared.open(
            name: name,
            access: access,
            options: options,
            permissions: permissions
        )
    }

    @unsafe
    @inlinable
    public static func unlink(name: UnsafePointer<CChar>) throws(Memory.Shared.Error) {
        try unsafe Memory.Shared.unlink(name: name)
    }
}
