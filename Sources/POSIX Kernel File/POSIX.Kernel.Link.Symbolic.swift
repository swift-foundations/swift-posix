public import ISO_9945_Kernel_File

extension POSIX.Kernel.Link {

    public enum Symbolic {}
}

extension POSIX.Kernel.Link.Symbolic {

    public typealias Error = ISO_9945.Kernel.Link.Symbolic.Error
}

extension POSIX.Kernel.Link.Symbolic {

    @inlinable
    public static func create(
        target: borrowing Path.Borrowed,
        at linkPath: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.Link.Symbolic.Error) {
        try ISO_9945.Kernel.Link.Symbolic.create(target: target, at: linkPath)
    }

    @inlinable
    public static func withTargetBytes<R: ~Copyable>(
        at path: borrowing Path.Borrowed,
        _ body: (Swift.Span<Path.Char>) -> R
    ) throws(ISO_9945.Kernel.Link.Symbolic.Error) -> R {
        try ISO_9945.Kernel.Link.Symbolic.withTargetBytes(at: path, body)
    }

    @inlinable
    public static func withTarget<R: ~Copyable>(
        at path: borrowing Path.Borrowed,
        _ body: (borrowing String.Borrowed) -> R
    ) throws(ISO_9945.Kernel.Link.Symbolic.Error) -> R {
        try ISO_9945.Kernel.Link.Symbolic.withTarget(at: path, body)
    }

    @inlinable
    public static func readTarget(
        at path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.Link.Symbolic.Error) -> String {
        try ISO_9945.Kernel.Link.Symbolic.readTarget(at: path)
    }
}
