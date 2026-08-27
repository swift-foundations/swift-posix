public import Error
public import ISO_9945_Core

extension POSIX.Kernel.Close {
    public enum Error: Swift.Error, Sendable {
        case handle(POSIX.Kernel.Descriptor.Validity.Error)
        case platform(Error.Error)
    }
}

extension POSIX.Kernel.Close.Error: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.handle(let l), .handle(let r)): return l == r
        case (.platform(let l), .platform(let r)): return l == r
        default: return false
        }
    }
}

extension POSIX.Kernel.Close.Error: CustomStringConvertible {
    public var description: Swift.String {
        switch self {
        case .handle(let e): return "handle: \(e)"
        case .platform(let e): return "\(e)"
        }
    }
}
