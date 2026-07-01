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

public import ISO_9945_Kernel_Socket

extension POSIX.Kernel.Socket {
    /// Cross-platform POSIX socket descriptor — L2-canonical at iso-9945.
    ///
    /// Per [PLAT-ARCH-005] revised (Wave 4c-Socket Prerequisite II, 2026-05-01):
    /// the per-platform Socket Descriptor is canonical at L2 (`ISO_9945.Kernel.Socket.Descriptor`,
    /// itself a typealias of `ISO_9945.Kernel.Descriptor` since fd=socket on POSIX);
    /// L3-policy contributes this typealias so the three-tier chain
    /// `Kernel.Socket.Descriptor → POSIX.Kernel.Socket.Descriptor → ISO_9945.Kernel.Socket.Descriptor`
    /// composes one tier at a time per [PLAT-ARCH-008e].
    public typealias Descriptor = ISO_9945.Kernel.Socket.Descriptor
}
