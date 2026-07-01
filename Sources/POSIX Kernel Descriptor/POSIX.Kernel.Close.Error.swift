// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-posix open source project
//
// Copyright (c) 2024 Coen ten Thije Boonkkamp and the swift-posix project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Error_Primitives
public import ISO_9945_Core  // Phase B4: POSIX.Kernel.Descriptor.Validity typealiases to ISO_9945.Kernel.Descriptor.Validity

extension POSIX.Kernel.Close {
    public enum Error: Swift.Error, Sendable {
        case handle(POSIX.Kernel.Descriptor.Validity.Error)
        case platform(Error_Primitives.Error)
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

// MARK: - Platform Bindings
//
// Per [PLAT-ARCH-008c], the platform-specific `init(code:)` mapping lives
// in L2 (`swift-iso-9945`).
