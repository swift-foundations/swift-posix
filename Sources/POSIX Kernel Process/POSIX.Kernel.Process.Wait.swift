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

public import ISO_9945_Kernel_Process

// MARK: - POSIX Process.Wait policy
//
// Wave 3.5-5 (2026-05-01) — Item 4 sub-cycle 5 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.Process.Wait.wait typed form.
// `waitpid(2)` IS EINTR-prone per POSIX spec — signal interruption is
// common (very EINTR-prone). Apply canonical EINTR retry via
// `error.code.isInterrupted` (Process.Error has public `.code` accessor).
//
// Wait returns `Result?` — the `nil` case is non-error (no-hang option +
// no child changed state). EINTR retry is on the throwing path only;
// successful `nil` returns pass through unchanged.

extension POSIX.Kernel.Process {
    /// Wait operations with EINTR retry policy.
    public enum Wait: Sendable {}
}

// MARK: - Wave 3.5-Final-5 (2026-05-02) — value-type typealiases for nested types

extension POSIX.Kernel.Process.Wait {
    /// Wait kind (struct) — typealias to canonical iso-9945 home.
    public typealias Kind = ISO_9945.Kernel.Process.Wait.Kind

    /// Wait options (struct OptionSet; Options.No nested chains transitively) —
    /// typealias to canonical iso-9945 home.
    public typealias Options = ISO_9945.Kernel.Process.Wait.Options

    /// Wait result (struct with pid + status) — typealias to canonical
    /// iso-9945 home.
    public typealias Result = ISO_9945.Kernel.Process.Wait.Result

    /// Wait selector (.any / .process / .group / .current) — typealias
    /// to canonical iso-9945 home.
    public typealias Selector = ISO_9945.Kernel.Process.Wait.Selector
}

extension POSIX.Kernel.Process.Wait {
    /// Waits for child process(es) to change state, automatically retrying
    /// on EINTR.
    ///
    /// Policy-aware wrapper around
    /// ``ISO_9945/Kernel/Process/Wait/wait(_:options:)``.
    /// `waitpid(2)` is very EINTR-prone (signal interruption common).
    ///
    /// - Parameters:
    ///   - selector: Which child(ren) to wait for.
    ///   - options: Wait options (default: blocking).
    /// - Returns: Result, or `nil` if `no.hang` and no child changed state.
    /// - Throws: ``ISO_9945/Kernel/Process/Error`` on failure (excluding EINTR).
    @inlinable
    public static func wait(
        _ selector: ISO_9945.Kernel.Process.Wait.Selector,
        options: ISO_9945.Kernel.Process.Wait.Options = []
    ) throws(ISO_9945.Kernel.Process.Error) -> ISO_9945.Kernel.Process.Wait.Result? {
        while true {
            do throws(ISO_9945.Kernel.Process.Error) {
                return try ISO_9945.Kernel.Process.Wait.wait(selector, options: options)
            } catch where error.code.isInterrupted {
                continue  // Retry on EINTR
            }
        }
    }
}
