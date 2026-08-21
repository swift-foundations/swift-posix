public import Error_Primitives
public import ISO_9945_Core

extension POSIX.Kernel.Close.Error {

    @inlinable
    public init(code: Error_Primitives.Error.Code) {
        if let e = POSIX.Kernel.Descriptor.Validity.Error(code: code) {
            self = .handle(e)
            return
        }
        self = .platform(Error_Primitives.Error(code: code))
    }
}
