public import Error
public import ISO_9945_Core

extension POSIX.Kernel.Close.Error {

    @inlinable
    public init(code: Error.Error.Code) {
        if let e = POSIX.Kernel.Descriptor.Validity.Error(code: code) {
            self = .handle(e)
            return
        }
        self = .platform(Error.Error(code: code))
    }
}
