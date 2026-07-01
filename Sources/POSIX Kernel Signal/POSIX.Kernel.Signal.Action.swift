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

public import ISO_9945_Kernel_Signal

// MARK: - POSIX Signal.Action policy
//
// Wave 3.5-6 (2026-05-01) — Item 4 sub-cycle 6 of post-Path-X cycles:
// Method-wrapped siblings of ISO_9945.Kernel.Signal.Action typed forms.
// `sigaction(2)` is NOT EINTR-prone per POSIX spec — pure pass-through
// for namespace symmetry.
//
// `@unsafe` gating preserved on set/get — signal handlers must be
// async-signal-safe per signal-safety(7); the `@unsafe` attribute
// signals this constraint to consumers.

extension POSIX.Kernel.Signal {
    /// Signal action (handler registration) operations.
    public enum Action: Sendable {}
}

// MARK: - Wave 3.5-Final-6 (2026-05-02) — value-type typealiases for nested types

extension POSIX.Kernel.Signal.Action {
    /// Action configuration (struct — sigaction wrapper) — typealias to
    /// canonical iso-9945 home.
    public typealias Configuration = ISO_9945.Kernel.Signal.Action.Configuration

    /// Action handler enum (.default / .ignore / .custom / .customInfo) —
    /// typealias to canonical iso-9945 home.
    public typealias Handler = ISO_9945.Kernel.Signal.Action.Handler

    /// Action options (struct OptionSet — sa_flags) — typealias to
    /// canonical iso-9945 home.
    public typealias Options = ISO_9945.Kernel.Signal.Action.Options
}

extension POSIX.Kernel.Signal.Action {
    /// Sets the signal action configuration for a signal, returning the
    /// previous configuration.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Signal/Action/set(signal:_:)``.
    /// `@unsafe` mirrors iso-9945's caller-async-signal-safety contract on
    /// the handler.
    ///
    /// - Parameters:
    ///   - signal: The signal to configure.
    ///   - configuration: The new signal action configuration.
    /// - Returns: The previous configuration.
    /// - Throws: ``ISO_9945/Kernel/Signal/Error`` on failure.
    @discardableResult
    @unsafe
    @inlinable
    public static func set(
        signal: ISO_9945.Kernel.Signal.Number,
        _ configuration: ISO_9945.Kernel.Signal.Action.Configuration
    ) throws(ISO_9945.Kernel.Signal.Error) -> ISO_9945.Kernel.Signal.Action.Configuration {
        try unsafe ISO_9945.Kernel.Signal.Action.set(signal: signal, configuration)
    }

    /// Gets the current signal action configuration for a signal.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Signal/Action/get(signal:)``.
    ///
    /// - Parameter signal: The signal to query.
    /// - Returns: The current signal action configuration.
    /// - Throws: ``ISO_9945/Kernel/Signal/Error`` on failure.
    @unsafe
    @inlinable
    public static func get(
        signal: ISO_9945.Kernel.Signal.Number
    ) throws(ISO_9945.Kernel.Signal.Error) -> ISO_9945.Kernel.Signal.Action.Configuration {
        try unsafe ISO_9945.Kernel.Signal.Action.get(signal: signal)
    }
}
