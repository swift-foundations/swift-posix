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

// MARK: - POSIX Process.Spawn policy
//
// Wave 3.5-5 (2026-05-01) — Item 4 sub-cycle 5 of post-Path-X cycles:
// Method-wrapped sibling of ISO_9945.Kernel.Process.Spawn.spawn typed form
// (Path.Char variant). `posix_spawn(3)` is NOT EINTR-prone per POSIX spec —
// pure pass-through for namespace symmetry.
//
// The CChar `@_spi(Syscall)` raw companion variant at iso-9945 is NOT
// wrapped per ground rule #4 — only the typed Phase 1.5 Path.Char variant
// is the wrapping target. Consumers needing the CChar shape reach the
// `@_spi(Syscall)` form directly through the L2 surface (out of L3-policy
// scope).

extension POSIX.Kernel.Process {
    /// Process spawn operations (posix_spawn).
    public enum Spawn: Sendable {}
}

extension POSIX.Kernel.Process.Spawn {
    /// Spawns a new process to execute the specified program using `Path.Char`
    /// pointers.
    ///
    /// Pass-through wrapper around iso-9945's `@unsafe` Path.Char variant.
    /// `@unsafe` mirrors the iso-9945 form's caller-NUL-termination contract
    /// on path/argv/envp.
    ///
    /// Unlike `fork()` followed by `exec()`, `posix_spawn()` does NOT
    /// duplicate the parent's address space — safe to use from multithreaded
    /// Swift processes.
    ///
    /// - Parameters:
    ///   - path: Path to the executable.
    ///   - argv: Argument vector (null-terminated array).
    ///   - envp: Environment vector (null-terminated array).
    /// - Returns: The process ID of the spawned child.
    /// - Throws: ``ISO_9945/Kernel/Process/Error`` on failure.
    @unsafe
    @inlinable
    public static func spawn(
        path: UnsafePointer<Path.Char>,
        argv: UnsafePointer<UnsafePointer<Path.Char>?>,
        envp: UnsafePointer<UnsafePointer<Path.Char>?>
    ) throws(ISO_9945.Kernel.Process.Error) -> ISO_9945.Kernel.Process.ID {
        try unsafe ISO_9945.Kernel.Process.Spawn.spawn(path: path, argv: argv, envp: envp)
    }
}
