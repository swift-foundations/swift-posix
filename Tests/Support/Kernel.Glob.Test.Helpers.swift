#if !os(Windows)

    public import Path_Primitives
    public import Glob_Primitives

    public func makePath(_ string: Swift.String) -> Path {
        let utf8 = Array(string.utf8)
        let buffer = UnsafeMutablePointer<Path.Char>.allocate(capacity: utf8.count + 1)
        for (i, byte) in utf8.enumerated() { unsafe buffer[i] = byte }
        unsafe buffer[utf8.count] = 0
        return unsafe Path(adopting: buffer, count: utf8.count)
    }

    extension Glob {

        public static func match(
            pattern: Pattern,
            in directory: Swift.String,
            options: Options = .init()
        ) throws(Error) -> [Swift.String] {
            let path = makePath(directory)
            return try match(pattern: pattern, in: path.view, options: options)
        }

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
