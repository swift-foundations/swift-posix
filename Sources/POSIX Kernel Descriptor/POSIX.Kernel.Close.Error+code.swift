// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-posix open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-posix project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Error_Primitives
public import ISO_9945_Core  // Phase B4: POSIX.Kernel.Descriptor.Validity typealiases to ISO_9945.Kernel.Descriptor.Validity

// MARK: - POSIX Error Code Mapping

extension POSIX.Kernel.Close.Error {
    /// Creates an error from a POSIX error code.
    @inlinable
    public init(code: Error_Primitives.Error.Code) {
        if let e = POSIX.Kernel.Descriptor.Validity.Error(code: code) {
            self = .handle(e)
            return
        }
        self = .platform(Error_Primitives.Error(code: code))
    }
}
