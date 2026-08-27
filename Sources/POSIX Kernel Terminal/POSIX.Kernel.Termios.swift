#if !os(Windows)

    @_spi(Syscall) public import ISO_9945_Kernel_Terminal
    @_spi(Syscall) public import POSIX_Kernel_Descriptor

    extension POSIX.Kernel {

        public enum Termios: Sendable {}
    }

    extension POSIX.Kernel.Termios {

        public enum Attributes {}
    }

    extension POSIX.Kernel.Termios.Attributes {

        public typealias Storage = ISO_9945.Kernel.Termios.Attributes.Storage

        public typealias Action = ISO_9945.Kernel.Termios.Attributes.Action
    }

    extension POSIX.Kernel.Termios.Attributes {

        public static func get(
            _ descriptor: borrowing POSIX.Kernel.Descriptor
        ) throws(Error.Error) -> ISO_9945.Kernel.Termios.Attributes {
            try ISO_9945.Kernel.Termios.Attributes.get(descriptor)
        }
    }

#endif
