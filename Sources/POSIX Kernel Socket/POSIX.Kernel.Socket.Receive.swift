public import ISO_9945_Kernel_Socket

extension POSIX.Kernel.Socket {

    public enum Receive {}
}

extension POSIX.Kernel.Socket.Receive {

    public static func receive(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        into span: inout MutableSpan<Byte>,
        options: ISO_9945.Kernel.Socket.Message.Options = []
    ) throws(ISO_9945.Kernel.Socket.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Receive.receive(
                    descriptor,
                    into: &span,
                    options: options
                )
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    public static func from(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        into span: inout MutableSpan<Byte>,
        options: ISO_9945.Kernel.Socket.Message.Options = []
    ) throws(ISO_9945.Kernel.Socket.Error) -> (
        count: Int, address: ISO_9945.Kernel.Socket.Address.Storage,
        addressLength: ISO_9945.Kernel.Socket.Address.Length
    ) {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Receive.from(
                    descriptor,
                    into: &span,
                    options: options
                )
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    public static func message(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        header: inout ISO_9945.Kernel.Socket.Message.Header,
        options: ISO_9945.Kernel.Socket.Message.Options = []
    ) throws(ISO_9945.Kernel.Socket.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Receive.message(
                    descriptor,
                    header: &header,
                    options: options
                )
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }
}
