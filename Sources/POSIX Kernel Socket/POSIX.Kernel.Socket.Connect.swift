@_spi(Syscall) public import ISO_9945_Kernel_Poll
@_spi(Syscall) public import ISO_9945_Kernel_Socket

extension POSIX.Kernel.Socket {

    public enum Connect {}
}

extension POSIX.Kernel.Socket.Connect {

    public static func start(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        address: ISO_9945.Kernel.Socket.Address.Storage,
        length: ISO_9945.Kernel.Socket.Address.Length
    ) throws(ISO_9945.Kernel.Socket.Error) -> Start {
        do throws(ISO_9945.Kernel.Socket.Error) {
            try ISO_9945.Kernel.Socket.Connect.connect(descriptor, address: address, length: length)
            return .connected
        } catch  where error.code.isInProgress || error.code.isInterrupted {
            return .pending
        }
    }

    public static func finish(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor
    ) throws(ISO_9945.Kernel.Socket.Error) {
        let code = try ISO_9945.Kernel.Socket.getError(descriptor)
        guard code == .posix(0) else {
            throw ISO_9945.Kernel.Socket.Error(code: code)
        }
    }

    public static func awaitCompletion(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor
    ) throws(ISO_9945.Kernel.Socket.Error) {
        var entries = [ISO_9945.Kernel.Poll.Entry(descriptor, requested: .output)]

        while true {
            do throws(Error.Error) {
                let ready = try ISO_9945.Kernel.Poll.poll(&entries, timeout: -1)
                if ready > 0 { break }
            } catch  where error.code.isInterrupted {
                continue
            } catch {
                throw .platform(error)
            }
        }

        let code = try ISO_9945.Kernel.Socket.getError(descriptor)
        guard code == .posix(0) else {
            throw .platform(Error.Error(code: code))
        }
    }
}

extension POSIX.Kernel.Socket.Connect {

    public static func connect(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        address: ISO_9945.Kernel.Socket.Address.Storage,
        length: ISO_9945.Kernel.Socket.Address.Length
    ) throws(ISO_9945.Kernel.Socket.Error) {
        do throws(ISO_9945.Kernel.Socket.Error) {
            try ISO_9945.Kernel.Socket.Connect.connect(descriptor, address: address, length: length)
        } catch  where error.code.isInterrupted {
            try awaitCompletion(descriptor)
        }
    }

    public static func connect(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        address: ISO_9945.Kernel.Socket.Address.IPv4
    ) throws(ISO_9945.Kernel.Socket.Error) {
        do throws(ISO_9945.Kernel.Socket.Error) {
            try ISO_9945.Kernel.Socket.Connect.connect(descriptor, address: address)
        } catch  where error.code.isInterrupted {
            try awaitCompletion(descriptor)
        }
    }

    public static func connect(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        address: ISO_9945.Kernel.Socket.Address.IPv6
    ) throws(ISO_9945.Kernel.Socket.Error) {
        do throws(ISO_9945.Kernel.Socket.Error) {
            try ISO_9945.Kernel.Socket.Connect.connect(descriptor, address: address)
        } catch  where error.code.isInterrupted {
            try awaitCompletion(descriptor)
        }
    }

    public static func connect(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        address: ISO_9945.Kernel.Socket.Address.Unix
    ) throws(ISO_9945.Kernel.Socket.Error) {
        do throws(ISO_9945.Kernel.Socket.Error) {
            try ISO_9945.Kernel.Socket.Connect.connect(descriptor, address: address)
        } catch  where error.code.isInterrupted {
            try awaitCompletion(descriptor)
        }
    }
}
