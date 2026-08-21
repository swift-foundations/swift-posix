public import ISO_9945_Kernel_Process

extension POSIX.Kernel.Process {

    public enum Session: Sendable {}
}

extension POSIX.Kernel.Process.Session {

    public typealias ID = ISO_9945.Kernel.Process.Session.ID
}

extension POSIX.Kernel.Process.Session {

    @inlinable
    public static func create() throws(ISO_9945.Kernel.Process.Error)
        -> ISO_9945.Kernel.Process.Session.ID
    {
        try ISO_9945.Kernel.Process.Session.create()
    }

    @inlinable
    public static func id(
        of pid: ISO_9945.Kernel.Process.ID
    ) throws(ISO_9945.Kernel.Process.Error) -> ISO_9945.Kernel.Process.Session.ID {
        try ISO_9945.Kernel.Process.Session.id(of: pid)
    }
}
