public import ISO_9945_Kernel_Environment

extension POSIX.Kernel {

    public enum Environment: Sendable {}
}

extension POSIX.Kernel.Environment {

    public typealias Error = ISO_9945.Kernel.Environment.Error

    public typealias Entry = ISO_9945.Kernel.Environment.Entry

    public typealias Entries = ISO_9945.Kernel.Environment.Entries
}

extension POSIX.Kernel.Environment {

    @inlinable
    @_lifetime(immortal)
    public static func entries() -> ISO_9945.Kernel.Environment.Entries {
        ISO_9945.Kernel.Environment.entries()
    }

    @inlinable
    public static func withValueBytes<R: ~Copyable>(
        _ name: UnsafePointer<String.Char>,
        _ body: (Swift.Span<String.Char>) -> R
    ) -> R? {
        unsafe ISO_9945.Kernel.Environment.withValueBytes(name, body)
    }

    @inlinable
    public static func withValue<R: ~Copyable>(
        _ name: UnsafePointer<String.Char>,
        _ body: (borrowing String.Borrowed) -> R
    ) -> R? {
        unsafe ISO_9945.Kernel.Environment.withValue(name, body)
    }

    @inlinable
    public static func get(_ name: UnsafePointer<String.Char>) -> String? {
        unsafe ISO_9945.Kernel.Environment.get(name)
    }

    @inlinable
    public static func set(
        _ name: UnsafePointer<String.Char>,
        to value: UnsafePointer<String.Char>,
        overwrite: Bool = true
    ) throws(ISO_9945.Kernel.Environment.Error) {
        try unsafe ISO_9945.Kernel.Environment.set(name, to: value, overwrite: overwrite)
    }

    @inlinable
    public static func unset(
        _ name: UnsafePointer<String.Char>
    ) throws(ISO_9945.Kernel.Environment.Error) {
        try unsafe ISO_9945.Kernel.Environment.unset(name)
    }
}
