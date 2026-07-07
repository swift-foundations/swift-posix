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

public import Glob_Primitives
internal import ISO_9945_Glob
internal import ISO_9945_Kernel_Directory
@_spi(Syscall) internal import ISO_9945_Kernel_File
public import Path_Primitives

// MARK: - POSIX Glob Implementation

extension Glob {
    /// Matches files using a glob pattern, yielding each match to the body closure.
    ///
    /// Streams results directly — no intermediate collection. Each matched path
    /// is yielded as it is found during directory traversal.
    ///
    /// - Parameters:
    ///   - pattern: Compiled glob pattern.
    ///   - directory: Root directory path for matching.
    ///   - options: Matching and traversal options.
    ///   - body: Closure called for each matching path.
    /// - Throws: `ISO_9945.Kernel.Glob.Error` on failure.
    public static func match(
        pattern: Pattern,
        in directory: borrowing Path.Borrowed,
        options: Options = .init(),
        body: (Swift.String) -> Void
    ) throws(Error) {
        let root = Path(directory.span)
        let segmentStrings: [Swift.String] = pattern.raw
            .split(separator: "/", omittingEmptySubsequences: false)
            .map { Swift.String($0) }

        if options.ordering == .deterministic {
            var results: [Swift.String] = []
            try matchSegments(
                pattern.segments,
                segmentStrings: segmentStrings,
                segmentIndex: 0,
                currentPath: root,
                options: options
            ) { results.append($0) }

            results.sort()
            for result in results {
                body(result)
            }
        } else {
            try matchSegments(
                pattern.segments,
                segmentStrings: segmentStrings,
                segmentIndex: 0,
                currentPath: root,
                options: options,
                body: body
            )
        }
    }

    /// Matches files using multiple patterns with exclusions, yielding each match.
    ///
    /// Collects internally for deduplication across patterns, then yields results.
    ///
    /// - Parameters:
    ///   - include: Patterns to include.
    ///   - excluding: Patterns to exclude.
    ///   - directory: Root directory path for matching.
    ///   - options: Matching and traversal options.
    ///   - body: Closure called for each matching path (after deduplication).
    /// - Throws: `ISO_9945.Kernel.Glob.Error` on failure.
    public static func match(
        include: [Pattern],
        excluding: [Pattern] = [],
        in directory: borrowing Path.Borrowed,
        options: Options = .init(),
        body: (Swift.String) -> Void
    ) throws(Error) {
        var allMatches: Set<Swift.String> = []

        for pattern in include {
            try match(pattern: pattern, in: directory, options: options) { path in
                allMatches.insert(path)
            }
        }

        for pattern in excluding {
            try match(pattern: pattern, in: directory, options: options) { path in
                allMatches.remove(path)
            }
        }

        if options.ordering == .deterministic {
            for result in allMatches.sorted() {
                body(result)
            }
        } else {
            for result in allMatches {
                body(result)
            }
        }
    }

    /// Convenience: matches files using a glob pattern, returning collected results.
    public static func match(
        pattern: Pattern,
        in directory: borrowing Path.Borrowed,
        options: Options = .init()
    ) throws(Error) -> [Swift.String] {
        var results: [Swift.String] = []
        try match(pattern: pattern, in: directory, options: options) { results.append($0) }
        return results
    }

    /// Convenience: matches files using multiple patterns with exclusions, returning collected results.
    public static func match(
        include: [Pattern],
        excluding: [Pattern] = [],
        in directory: borrowing Path.Borrowed,
        options: Options = .init()
    ) throws(Error) -> [Swift.String] {
        var results: [Swift.String] = []
        try match(include: include, excluding: excluding, in: directory, options: options) { results.append($0) }
        return results
    }
}

// MARK: - Private Implementation

extension Glob {
    /// Recursively matches segments against the filesystem, yielding each match.
    private static func matchSegments(
        _ segments: [Segment],
        segmentStrings: [Swift.String],
        segmentIndex: Int,
        currentPath: borrowing Path,
        options: Options,
        depth: Int = 0,
        body: (Swift.String) -> Void
    ) throws(Error) {
        if let maxDepth = options.maxDepth, depth > maxDepth {
            return
        }

        guard segmentIndex < segments.count else {
            // Yield matched path as Swift.String for Copyable collection/sorting
            body(unsafe Swift.String(cString: UnsafeRawPointer(currentPath.view.pointer).assumingMemoryBound(to: CChar.self)))
            return
        }

        let segment = segments[segmentIndex]

        switch segment {
        case .literal(let name):
            let nextPath = appendPath(currentPath, name)
            if pathExists(nextPath.view) {
                try matchSegments(
                    segments,
                    segmentStrings: segmentStrings,
                    segmentIndex: segmentIndex + 1,
                    currentPath: nextPath,
                    options: options,
                    depth: depth,
                    body: body
                )
            }

        case .pattern:
            let entries = try listDirectory(currentPath.view, options: options)

            // Build fnmatch flags from L1 options
            var fnmatchFlags: ISO_9945.Glob.Fnmatch.Options = [.pathname]
            if options.caseInsensitive { fnmatchFlags.insert(.casefold) }
            if options.dotfiles == .explicit { fnmatchFlags.insert(.period) }

            // Convert pattern segment to path view and match against entries.
            // Pattern strings from pattern.raw should never contain interior NUL;
            // if conversion fails, treat as no matches.
            let matchedEntries: [ISO_9945.Kernel.Directory.Entry]
            do {
                matchedEntries = try Path.scope(segmentStrings[segmentIndex]) { segmentView in
                    entries.filter { entry in
                        if shouldSkipEntry(entry, options: options, forDoubleStar: false) { return false }
                        return ISO_9945.Glob.fnmatch(
                            pattern: segmentView,
                            name: entry.name,
                            options: fnmatchFlags
                        )
                    }
                }
            } catch {
                matchedEntries = []
            }

            for entry in matchedEntries {
                let nextPath = appendPath(currentPath, entry)
                try matchSegments(
                    segments,
                    segmentStrings: segmentStrings,
                    segmentIndex: segmentIndex + 1,
                    currentPath: nextPath,
                    options: options,
                    depth: depth,
                    body: body
                )
            }

        case .doubleStar:
            try matchSegments(
                segments,
                segmentStrings: segmentStrings,
                segmentIndex: segmentIndex + 1,
                currentPath: currentPath,
                options: options,
                depth: depth,
                body: body
            )

            let entries = try listDirectory(currentPath.view, options: options)
            // `**` is the pattern's last segment — file entries beneath it
            // are leaf matches, not just intermediate dirs to descend.
            let isTerminalDoubleStar = segmentIndex + 1 == segments.count
            for entry in entries {
                if shouldSkipEntry(entry, options: options, forDoubleStar: true) {
                    continue
                }

                let nextPath = appendPath(currentPath, entry)

                // Use d_type when available to avoid stat() syscall
                let entryIsDir: Bool =
                    if let type = entry.type {
                        type == .directory
                    } else {
                        isDirectory(nextPath.view, followSymlinks: options.followSymlinks)
                    }

                if entryIsDir {
                    try matchSegments(
                        segments,
                        segmentStrings: segmentStrings,
                        segmentIndex: segmentIndex,
                        currentPath: nextPath,
                        options: options,
                        depth: depth + 1,
                        body: body
                    )
                } else if isTerminalDoubleStar {
                    body(unsafe Swift.String(cString: UnsafeRawPointer(nextPath.view.pointer).assumingMemoryBound(to: CChar.self)))
                }
            }
        }
    }

    /// Checks if an entry should be skipped based on dotfile policy.
    ///
    /// Operates on `name` bytes directly — no Swift.String allocation.
    private static func shouldSkipEntry(
        _ entry: ISO_9945.Kernel.Directory.Entry,
        options: Options,
        forDoubleStar: Bool
    ) -> Bool {
        let name = entry.name
        guard name.count > 0,
            unsafe name.pointer[0] == ASCII.Character.Graphic.period
        else { return false }
        guard !entry.isDotOrDotDot else { return false }

        switch options.dotfiles {
        case .always:
            return false

        case .never:
            return true

        case .explicit:
            return forDoubleStar
        }
    }
}

// MARK: - Filesystem Helpers

extension Glob {
    /// Lists directory entries via L2 `ISO_9945.Kernel.Directory.Stream`.
    ///
    /// Returns raw `ISO_9945.Kernel.Directory.Entry` values — callers use `rawName`
    /// for path construction and `name` only when pattern matching requires it.
    private static func listDirectory(
        _ path: borrowing Path.Borrowed,
        options: Options
    ) throws(Error) -> [ISO_9945.Kernel.Directory.Entry] {
        let stream: ISO_9945.Kernel.Directory.Stream
        do throws(ISO_9945.Kernel.Directory.Error) {
            stream = try ISO_9945.Kernel.Directory.open(at: path)
        } catch {
            if options.onError == .skip { return [] }
            throw Self.Error(from: error, pathView: path)
        }
        defer { stream.close() }

        var entries: [ISO_9945.Kernel.Directory.Entry] = []
        do throws(ISO_9945.Kernel.Directory.Error) {
            while let entry = try stream.next() {
                guard !entry.isDotOrDotDot else { continue }
                entries.append(entry)
            }
        } catch {
            if options.onError != .skip {
                throw Self.Error(from: error, pathView: path)
            }
        }

        return entries
    }

    /// Checks if path exists via L2 `ISO_9945.Kernel.File.Stats`.
    private static func pathExists(_ path: borrowing Path.Borrowed) -> Bool {
        do {
            _ = try ISO_9945.Kernel.File.Stats.get(path: path)
            return true
        } catch {
            return false
        }
    }

    /// Checks if path is a directory via L2 `ISO_9945.Kernel.File.Stats`.
    private static func isDirectory(_ path: borrowing Path.Borrowed, followSymlinks: Bool) -> Bool {
        let stats: ISO_9945.Kernel.File.Stats?
        do {
            stats =
                followSymlinks
                ? try ISO_9945.Kernel.File.Stats.get(path: path)
                : try ISO_9945.Kernel.File.Stats.lget(path: path)
        } catch {
            stats = nil
        }
        return stats?.type == .directory
    }

    /// Appends a directory entry's name to a path.
    ///
    /// Constructs the path directly from `name` bytes — no Swift.String
    /// allocation or Path.scope round-trip. Uses the same separator and
    /// null-termination logic as `Path.Protocol.appending`.
    ///
    /// `name.count` excludes the NUL terminator that backs the entry's raw bytes.
    private static func appendPath(
        _ base: borrowing Path,
        _ entry: ISO_9945.Kernel.Directory.Entry
    ) -> Path {
        let baseView = base.view
        let name = entry.name
        let nameCount = name.count
        let needsSep = unsafe baseView.count > 0 && baseView.pointer[baseView.count - 1] != ASCII.Character.Graphic.slant
        let sepSize = needsSep ? 1 : 0
        let totalCount = baseView.count + sepSize + nameCount

        let buffer = UnsafeMutablePointer<Path.Char>.allocate(capacity: totalCount + 1)
        unsafe buffer.initialize(from: baseView.pointer, count: baseView.count)
        var offset = baseView.count
        if needsSep {
            unsafe buffer[offset] = ASCII.Character.Graphic.slant
            offset += 1
        }
        unsafe buffer.advanced(by: offset).initialize(from: name.pointer, count: nameCount)
        unsafe buffer[totalCount] = 0

        return unsafe Path(adopting: buffer, count: totalCount)
    }

    /// Appends literal bytes to a path.
    ///
    /// Constructs the path directly from UTF-8 bytes — no String allocation
    /// or Path.scope round-trip. Same buffer pattern as entry-based appendPath.
    private static func appendPath(
        _ base: borrowing Path,
        _ component: [UInt8]
    ) -> Path {
        let baseView = base.view
        let needsSep = unsafe baseView.count > 0 && baseView.pointer[baseView.count - 1] != ASCII.Character.Graphic.slant
        let sepSize = needsSep ? 1 : 0
        let totalCount = baseView.count + sepSize + component.count

        let buffer = UnsafeMutablePointer<Path.Char>.allocate(capacity: totalCount + 1)
        unsafe buffer.initialize(from: baseView.pointer, count: baseView.count)
        var offset = baseView.count
        if needsSep {
            unsafe buffer[offset] = ASCII.Character.Graphic.slant
            offset += 1
        }
        for (i, byte) in component.enumerated() {
            unsafe buffer[offset + i] = byte
        }
        unsafe buffer[totalCount] = 0

        return unsafe Path(adopting: buffer, count: totalCount)
    }
}

// MARK: - Error Mapping

extension Glob.Error {
    /// Maps L2 directory errors to L1 glob errors.
    init(from error: ISO_9945.Kernel.Directory.Error, pathView: borrowing Path.Borrowed) {
        let path = unsafe Swift.String(cString: UnsafeRawPointer(pathView.pointer).assumingMemoryBound(to: CChar.self))
        self.init(from: error, path: path)
    }

    /// Maps L2 directory errors to L1 glob errors.
    init(from error: ISO_9945.Kernel.Directory.Error, path: Swift.String) {
        switch error {
        case .permission:
            self = .accessDenied(path: path)

        case .notFound:
            self = .notFound(path: path)

        case .notDirectory:
            self = .notDirectory(path: path)

        case .tooManyOpenFiles:
            self = .io(path: path, category: .tooManyOpenFiles)

        case .io, .platform:
            self = .io(path: path, category: .read)
        }
    }
}
