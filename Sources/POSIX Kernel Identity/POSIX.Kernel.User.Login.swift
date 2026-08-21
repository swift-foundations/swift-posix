public import ISO_9945_Kernel_Identity

extension POSIX.Kernel.User {

    public enum Login: Sendable {}
}

extension POSIX.Kernel.User.Login {

    @inlinable
    public static func name() throws(ISO_9945.Kernel.User.Login.Error) -> String? {
        try ISO_9945.Kernel.User.Login.name()
    }
}
