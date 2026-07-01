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

// MARK: - POSIX Process.Execute policy
//
// Wave 3.5-5 (2026-05-01) — Item 4 sub-cycle 5 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.Process.Execute.execve typed form.
// `execve(2)` is NOT EINTR-prone per POSIX spec — pure pass-through for
// namespace symmetry.
//
// `execve` only returns on FAILURE (success transfers control to the new
// program). Wrapper preserves this semantic: throws on failure, never
// returns on success.

extension POSIX.Kernel.Process {
    /// Process execution operations.
    public enum Execute: Sendable {}
}

extension POSIX.Kernel.Process.Execute {
    /// Executes a new program in the current process, replacing the current
    /// process image.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Kernel/Process/Execute/execve(path:argv:envp:)``.
    /// `@unsafe` mirrors the iso-9945 form's caller-NUL-termination contract
    /// on path/argv/envp.
    ///
    /// - Parameters:
    ///   - path: Path to the executable (null-terminated C string).
    ///   - argv: Argument vector (null-terminated array of C strings).
    ///   - envp: Environment vector (null-terminated array of C strings).
    /// - Throws: ``ISO_9945/Kernel/Process/Error`` on failure. Never returns on success.
    @unsafe
    @inlinable
    public static func execve(
        path: UnsafePointer<CChar>,
        argv: UnsafePointer<UnsafePointer<CChar>?>,
        envp: UnsafePointer<UnsafePointer<CChar>?>
    ) throws(ISO_9945.Kernel.Process.Error) {
        try unsafe ISO_9945.Kernel.Process.Execute.execve(path: path, argv: argv, envp: envp)
    }
}
