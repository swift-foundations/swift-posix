public import ISO_9945_Core

extension POSIX.Kernel {

    public enum Close: Sendable {}
}

extension POSIX.Kernel.Close {

    public static func close(_ descriptor: consuming POSIX.Kernel.Descriptor) throws(Error) {
        do throws(ISO_9945.Kernel.Close.Error) {
            try ISO_9945.Kernel.Close.close(descriptor)
        } catch {
            switch error {
            case .handle(let e):
                throw .handle(e)

            case .platform(let e):
                throw .platform(e)
            }
        }
    }
}
