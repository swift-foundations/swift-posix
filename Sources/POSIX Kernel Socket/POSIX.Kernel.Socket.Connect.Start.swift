extension POSIX.Kernel.Socket.Connect {

    public enum Start: Sendable {

        case connected

        case pending
    }
}
