public import ISO_9945_Kernel_Process

extension POSIX.Kernel.Process {

    public enum Group: Sendable {}
}

extension POSIX.Kernel.Process.Group {

    public typealias ID = ISO_9945.Kernel.Process.Group.ID

    public typealias Process = ISO_9945.Kernel.Process.Group.Process

    public typealias Target = ISO_9945.Kernel.Process.Group.Target
}

extension POSIX.Kernel.Process.Group {

    @inlinable
    public static func set(
        _ process: ISO_9945.Kernel.Process.Group.Process,
        to target: ISO_9945.Kernel.Process.Group.Target
    ) throws(ISO_9945.Kernel.Process.Error) {
        try ISO_9945.Kernel.Process.Group.set(process, to: target)
    }

    @inlinable
    public static func id(
        of pid: ISO_9945.Kernel.Process.ID
    ) throws(ISO_9945.Kernel.Process.Error) -> ISO_9945.Kernel.Process.Group.ID {
        try ISO_9945.Kernel.Process.Group.id(of: pid)
    }
}
