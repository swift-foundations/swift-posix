public import ISO_9945_Kernel_Directory

extension POSIX.Kernel.Directory {

    public enum Working: Sendable {}
}

extension POSIX.Kernel.Directory.Working {

    public typealias Error = ISO_9945.Kernel.Directory.Working.Error
}

extension POSIX.Kernel.Directory.Working {

    @inlinable
    public static func current(
        into buffer: UnsafeMutableBufferPointer<CChar>
    ) throws(ISO_9945.Kernel.Directory.Working.Error) -> Int {
        try unsafe ISO_9945.Kernel.Directory.Working.current(into: buffer)
    }

    @inlinable
    public static func withCurrentBytes<R: ~Copyable>(
        _ body: (Swift.Span<Path.Char>) -> R
    ) throws(ISO_9945.Kernel.Directory.Working.Error) -> R {
        try ISO_9945.Kernel.Directory.Working.withCurrentBytes(body)
    }

    @inlinable
    public static func withCurrent<R: ~Copyable>(
        _ body: (borrowing String.Borrowed) -> R
    ) throws(ISO_9945.Kernel.Directory.Working.Error) -> R {
        try ISO_9945.Kernel.Directory.Working.withCurrent(body)
    }

    @inlinable
    public static func current() throws(ISO_9945.Kernel.Directory.Working.Error) -> String {
        try ISO_9945.Kernel.Directory.Working.current()
    }
}
