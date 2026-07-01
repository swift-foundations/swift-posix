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

public import ISO_9945_Kernel_Time

// MARK: - POSIX Time policy (deliberately empty)
//
// `clock_gettime(CLOCK_REALTIME, ...)` is signal-safe atomic per POSIX spec —
// NOT EINTR-prone, no validation, no transformation. There is no L3-policy
// substance for Time, so the L3 wrapper would be a gratuitous delegation
// (per `feedback_no_gratuitous_l3_delegation`).
//
// The pre-Wave-3.5-Corrective-4 cross-module extension that wrapped
// `realtime()` at this layer was the source of the 16th infinite-recursion
// site (Swift's overload resolution preferred the L3 same-signature form).
// Per the Tagged+Carrier migration disposition (Path B): delete the wrapper,
// keep only the namespace typealias.
//
// Consumers calling `Kernel.Time.realtime()` resolve through the typealias
// chain `Kernel.Time → POSIX.Kernel.Time → ISO_9945.Kernel.Time → Instant`
// (with `Kernel = POSIX.Kernel` Final-Atomic flip) directly to iso-9945's
// `realtime()` static method (now plain `public` post-Phase-1 SPI revert).

extension POSIX.Kernel {
    /// Wall-clock time (typealias to canonical iso-9945 typealias chain
    /// → L1 `Instant` struct).
    ///
    /// No Tagged migration — Time has no L3-policy substance (`clock_gettime`
    /// is signal-safe atomic, no retry/validation/transformation needed).
    public typealias Time = ISO_9945.Kernel.Time
}
