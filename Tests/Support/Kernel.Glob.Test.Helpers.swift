// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-posix open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-posix project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

#if !os(Windows)

    public import Path_Primitives
    public import Glob_Primitives

    // MARK: - Test Path Construction

    /// Creates an owned `Path` from a `Swift.String`.
    ///
    /// Test-only helper. Production code receives `Path.Borrowed` directly.
    /// POSIX paths cannot contain interior NULs, so the conversion is safe.
    public func makePath(_ string: Swift.String) -> Path {
        let utf8 = Array(string.utf8)
        let buffer = UnsafeMutablePointer<Path.Char>.allocate(capacity: utf8.count + 1)
        for (i, byte) in utf8.enumerated() { unsafe buffer[i] = byte }
        unsafe buffer[utf8.count] = 0
        return unsafe Path(adopting: buffer, count: utf8.count)
    }

    // MARK: - Glob String Convenience (Test-Only)

    extension Glob {
        /// Test convenience: matches files with a `Swift.String` directory.
        public static func match(
            pattern: Pattern,
            in directory: Swift.String,
            options: Options = .init()
        ) throws(Error) -> [Swift.String] {
            let path = makePath(directory)
            return try match(pattern: pattern, in: path.view, options: options)
        }

        /// Test convenience: multi-pattern match with a `Swift.String` directory.
        public static func match(
            include: [Pattern],
            excluding: [Pattern] = [],
            in directory: Swift.String,
            options: Options = .init()
        ) throws(Error) -> [Swift.String] {
            let path = makePath(directory)
            return try match(
                include: include,
                excluding: excluding,
                in: path.view,
                options: options
            )
        }

        /// Test convenience: streaming match with a `Swift.String` directory.
        public static func match(
            pattern: Pattern,
            in directory: Swift.String,
            options: Options = .init(),
            body: (Swift.String) -> Void
        ) throws(Error) {
            let path = makePath(directory)
            try match(pattern: pattern, in: path.view, options: options, body: body)
        }
    }

#endif
