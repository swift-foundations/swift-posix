public import ISO_9945_Kernel_Process

extension POSIX.Kernel.Process {

    public enum Spawn: Sendable {}
}

extension POSIX.Kernel.Process.Spawn {

    @unsafe
    @inlinable
    public static func spawn(
        path: UnsafePointer<Path.Char>,
        argv: UnsafePointer<UnsafePointer<Path.Char>?>,
        envp: UnsafePointer<UnsafePointer<Path.Char>?>
    ) throws(ISO_9945.Kernel.Process.Error) -> ISO_9945.Kernel.Process.ID {
        try unsafe ISO_9945.Kernel.Process.Spawn.spawn(path: path, argv: argv, envp: envp)
    }
}
