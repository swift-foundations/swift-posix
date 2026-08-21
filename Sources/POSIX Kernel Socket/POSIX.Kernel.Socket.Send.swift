public import ISO_9945_Kernel_Socket

extension POSIX.Kernel.Socket {

    public enum Send {}
}

extension POSIX.Kernel.Socket.Send {

    public static func send(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        from span: Swift.Span<Byte>,
        options: ISO_9945.Kernel.Socket.Message.Options = []
    ) throws(ISO_9945.Kernel.Socket.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Send.send(
                    descriptor,
                    from: span,
                    options: options
                )
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    public static func to(
        _ descriptor: borrowing ISO_9945.Kernel.Socket.Descriptor,
        from span: Swift.Span<Byte>,
        options: ISO_9945.Kernel.Socket.Message.Options = [],
        address: ISO_9945.Kernel.Socket.Address.Storage,
        addressLength: ISO_9945.Kernel.Socket.Address.Length
    ) throws(ISO_9945.Kernel.Socket.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.Socket.Error) {
                return try ISO_9945.Kernel.Socket.Send.to(
                    descriptor,
                    from: span,
                    options: options,
                    address: address,
                    addressLength: addressLength
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
                return try ISO_9945.Kernel.Socket.Send.message(
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
