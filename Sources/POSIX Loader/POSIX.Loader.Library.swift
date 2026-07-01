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

public import ISO_9945_Loader
public import Loader_Primitives  // for Loader.Error, Loader.Library.Handle

// MARK: - POSIX Loader.Library policy
//
// Wave 3.5-8 (2026-05-02) — pass-through wrappers of
// ISO_9945.Loader.Library typed Phase 1.5 forms (open/close).
// `dlopen(3)` / `dlclose(3)` are NOT EINTR-prone per POSIX spec — pure
// pass-through for namespace symmetry.

extension POSIX.Loader {
    /// Dynamic library load/unload operations.
    public enum Library: Sendable {}
}

// MARK: - Wave 3.5-Final-8 (2026-05-02) — value-type typealiases for Library.Handle + Library.Options
//
// Handle struct lives at L1 (`Loader_Primitives.Loader.Library.Handle`);
// Options struct OptionSet lives at iso-9945 (`ISO_9945.Loader.Library.Options`).
// Both routed via ISO_9945.Loader.Library.X per [PLAT-ARCH-008e]
// composition discipline (Handle resolves transitively to L1 via
// iso-9945's Loader typealias).

extension POSIX.Loader.Library {
    /// Loader library handle (`@unchecked Sendable, Equatable` struct
    /// at L1) — typealias to canonical iso-9945 home (which transitively
    /// resolves to L1 `Loader_Primitives.Loader.Library.Handle`).
    public typealias Handle = ISO_9945.Loader.Library.Handle

    /// Loader library load options (OptionSet struct at iso-9945) —
    /// typealias to canonical iso-9945 home.
    public typealias Options = ISO_9945.Loader.Library.Options
}

extension POSIX.Loader.Library {
    /// Opens a dynamic library.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Loader/Library/open(path:options:)``.
    /// Wraps `dlopen(3)`. `@unsafe` mirrors iso-9945's caller-NUL-termination
    /// contract on `path`.
    ///
    /// - Parameters:
    ///   - path: Path to the library, or `nil` for the main executable.
    ///   - options: Loading options (default `.now` — fail-early).
    /// - Returns: Handle to the loaded library.
    /// - Throws: `Loader.Error` on failure.
    @unsafe
    @inlinable
    public static func open(
        path: UnsafePointer<CChar>?,
        options: ISO_9945.Loader.Library.Options = .now
    ) throws(Loader.Error) -> Loader.Library.Handle {
        try unsafe ISO_9945.Loader.Library.open(path: path, options: options)
    }

    /// Closes a dynamic library.
    ///
    /// Pass-through wrapper around
    /// ``ISO_9945/Loader/Library/close(_:)``.
    /// Wraps `dlclose(3)`.
    ///
    /// - Parameter handle: The library handle to close.
    /// - Throws: `Loader.Error` on failure.
    @unsafe
    @inlinable
    public static func close(_ handle: Loader.Library.Handle) throws(Loader.Error) {
        try unsafe ISO_9945.Loader.Library.close(handle)
    }
}
