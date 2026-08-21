public enum POSIX {}

extension POSIX {

    public enum Kernel {}
}

extension POSIX.Kernel {

    public enum File {}
}

extension POSIX.Kernel.File {

    public typealias Handle = ISO_9945.Kernel.File.Handle
}
