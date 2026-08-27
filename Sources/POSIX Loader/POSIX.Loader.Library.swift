public import ISO_9945_Loader
public import Loader_Vocabulary

extension POSIX.Loader {

    public enum Library: Sendable {}
}

extension POSIX.Loader.Library {

    public typealias Handle = ISO_9945.Loader.Library.Handle

    public typealias Options = ISO_9945.Loader.Library.Options
}

extension POSIX.Loader.Library {

    @unsafe
    @inlinable
    public static func open(
        path: UnsafePointer<CChar>?,
        options: ISO_9945.Loader.Library.Options = .now
    ) throws(Loader.Error) -> Loader.Library.Handle {
        try unsafe ISO_9945.Loader.Library.open(path: path, options: options)
    }

    @unsafe
    @inlinable
    public static func close(_ handle: Loader.Library.Handle) throws(Loader.Error) {
        try unsafe ISO_9945.Loader.Library.close(handle)
    }
}
