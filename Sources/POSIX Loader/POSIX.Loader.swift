public import ISO_9945_Loader

extension POSIX {

    public enum Loader: Sendable {}
}

extension POSIX.Loader {

    public typealias Error = ISO_9945.Loader.Error
}
