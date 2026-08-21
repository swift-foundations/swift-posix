#if !os(Windows)

    @_spi(Syscall) public import ISO_9945_Kernel_Terminal
    @_spi(Syscall) public import POSIX_Kernel_Descriptor

    extension POSIX.Kernel {

        public enum TTY: Sendable {}
    }

    extension POSIX.Kernel.TTY {

        public enum Size {}
    }

    extension POSIX.Kernel.TTY {

        public static func isTTY(_ descriptor: borrowing POSIX.Kernel.Descriptor) -> Bool {
            ISO_9945.Kernel.TTY.isTTY(descriptor)
        }
    }

    extension POSIX.Kernel.TTY.Size {

        public static func query(
            _ descriptor: borrowing POSIX.Kernel.Descriptor
        ) throws(Error_Primitives.Error) -> ISO_9945.Kernel.TTY.Size {
            try ISO_9945.Kernel.TTY.Size.query(descriptor)
        }
    }

#endif
