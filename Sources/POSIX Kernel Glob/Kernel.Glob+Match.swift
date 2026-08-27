public import Glob
internal import ISO_9945_Glob
internal import ISO_9945_Kernel_Directory
@_spi(Syscall) internal import ISO_9945_Kernel_File
public import Path

extension Glob {

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

    public static func match(
        pattern: Pattern,
        in directory: borrowing Path.Borrowed,
        options: Options = .init()
    ) throws(Error) -> [Swift.String] {
        var results: [Swift.String] = []
        try match(pattern: pattern, in: directory, options: options) { results.append($0) }
        return results
    }

    public static func match(
        include: [Pattern],
        excluding: [Pattern] = [],
        in directory: borrowing Path.Borrowed,
        options: Options = .init()
    ) throws(Error) -> [Swift.String] {
        var results: [Swift.String] = []
        try match(include: include, excluding: excluding, in: directory, options: options) {
            results.append($0)
        }
        return results
    }
}

extension Glob {

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

            body(
                unsafe Swift.String(
                    cString: UnsafeRawPointer(currentPath.view.pointer).assumingMemoryBound(
                        to: CChar.self
                    )
                )
            )
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

            var fnmatchFlags: ISO_9945.Glob.Fnmatch.Options = [.pathname]
            if options.caseInsensitive { fnmatchFlags.insert(.casefold) }
            if options.dotfiles == .explicit { fnmatchFlags.insert(.period) }

            let matchedEntries: [ISO_9945.Kernel.Directory.Entry]
            do throws(Path.String.Conversion.Error) {
                matchedEntries = try Path.scope(segmentStrings[segmentIndex]) { segmentView in
                    entries.filter { entry in
                        if shouldSkipEntry(entry, options: options, forDoubleStar: false) {
                            return false
                        }
                        return entry.withName { name in

                            {
                                do throws(ISO_9945.Glob.Fnmatch.Error) {
                                    return try ISO_9945.Glob.fnmatch(
                                        pattern: segmentView,
                                        name: name,
                                        options: fnmatchFlags
                                    )
                                } catch {
                                    return false
                                }
                            }()
                        }
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

            let isTerminalDoubleStar = segmentIndex + 1 == segments.count
            for entry in entries {
                if shouldSkipEntry(entry, options: options, forDoubleStar: true) {
                    continue
                }

                let nextPath = appendPath(currentPath, entry)

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
                    body(
                        unsafe Swift.String(
                            cString: UnsafeRawPointer(nextPath.view.pointer).assumingMemoryBound(
                                to: CChar.self
                            )
                        )
                    )
                }
            }
        }
    }

    private static func shouldSkipEntry(
        _ entry: ISO_9945.Kernel.Directory.Entry,
        options: Options,
        forDoubleStar: Bool
    ) -> Bool {
        let startsWithPeriod = entry.withName { name in
            guard name.count > 0 else { return false }
            return unsafe name.pointer[0] == ASCII.Character.Graphic.period
        }
        guard startsWithPeriod else { return false }
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

extension Glob {

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

    private static func pathExists(_ path: borrowing Path.Borrowed) -> Bool {
        do throws(ISO_9945.Kernel.File.Stats.Error) {
            _ = try ISO_9945.Kernel.File.Stats.get(path: path)
            return true
        } catch {
            return false
        }
    }

    private static func isDirectory(_ path: borrowing Path.Borrowed, followSymlinks: Bool) -> Bool {
        let stats: ISO_9945.Kernel.File.Stats?
        do throws(ISO_9945.Kernel.File.Stats.Error) {
            stats =
                followSymlinks
                ? try ISO_9945.Kernel.File.Stats.get(path: path)
                : try ISO_9945.Kernel.File.Stats.lget(path: path)
        } catch {
            stats = nil
        }
        return stats?.type == .directory
    }

    private static func appendPath(
        _ base: borrowing Path,
        _ entry: ISO_9945.Kernel.Directory.Entry
    ) -> Path {
        let baseView = base.view
        let needsSep =
            unsafe baseView.count > 0
            && baseView.pointer[baseView.count - 1] != ASCII.Character.Graphic.slant
        let sepSize = needsSep ? 1 : 0

        let (buffer, totalCount): (UnsafeMutablePointer<Path.Char>, Int) = unsafe entry.withName {
            name in
            let nameCount = name.count
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

            return unsafe (buffer, totalCount)
        }

        return unsafe Path(adopting: buffer, count: totalCount)
    }

    private static func appendPath(
        _ base: borrowing Path,
        _ component: [UInt8]
    ) -> Path {
        let baseView = base.view
        let needsSep =
            unsafe baseView.count > 0
            && baseView.pointer[baseView.count - 1] != ASCII.Character.Graphic.slant
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

extension Glob.Error {

    init(from error: ISO_9945.Kernel.Directory.Error, pathView: borrowing Path.Borrowed) {
        let path = unsafe Swift.String(
            cString: UnsafeRawPointer(pathView.pointer).assumingMemoryBound(to: CChar.self)
        )
        self.init(from: error, path: path)
    }

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

        case .closed:
            self = .io(path: path, category: .other)
        }
    }
}
