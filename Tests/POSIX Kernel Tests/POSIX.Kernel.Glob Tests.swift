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

import Testing

import POSIX_Test_Support
@testable import POSIX_Kernel

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

extension Glob {
    enum Test {
        @Suite struct Unit {}
        @Suite struct EdgeCase {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

// MARK: - Test Fixture

/// Recursively removes a directory and its contents.
private func removeDirectoryRecursively(_ path: Swift.String) {
    guard let dir = opendir(path) else { return }
    defer { closedir(dir) }

    while let entry = readdir(dir) {
        let name = withUnsafePointer(to: entry.pointee.d_name) { ptr in
            ptr.withMemoryRebound(to: CChar.self, capacity: Int(NAME_MAX)) { cstr in
                Swift.String(cString: cstr)
            }
        }

        if name == "." || name == ".." { continue }

        let fullPath = path + "/" + name
        var st = stat()
        if lstat(fullPath, &st) == 0 {
            if (st.st_mode & S_IFMT) == S_IFDIR {
                removeDirectoryRecursively(fullPath)
            } else {
                unlink(fullPath)
            }
        }
    }
    rmdir(path)
}

/// Gets the parent directory path.
private func parentDirectory(of path: Swift.String) -> Swift.String {
    var components = path.split(separator: "/", omittingEmptySubsequences: false)
    if components.count > 1 {
        components.removeLast()
    }
    if components.isEmpty || (components.count == 1 && components[0].isEmpty) {
        return "/"
    }
    return components.joined(separator: "/")
}

/// Creates a temporary directory structure for glob testing.
private func withTestDirectory(
    _ body: (Swift.String) throws -> Void
) throws {
    let template = "/tmp/glob-test-XXXXXX"
    var templateBytes = Array(template.utf8CString)
    guard let dir = mkdtemp(&templateBytes) else {
        throw Glob.Error.io(path: template, category: .other)
    }
    let tempDir = Swift.String(cString: dir)

    defer {
        removeDirectoryRecursively(tempDir)
    }

    try body(tempDir)
}

/// Creates files and directories in the test directory.
private func createTestFiles(in directory: Swift.String) throws {
    // Create directory structure:
    // directory/
    //   file1.txt
    //   file2.txt
    //   file3.md
    //   .hidden.txt
    //   src/
    //     main.swift
    //     test.swift
    //     util.swift
    //   docs/
    //     readme.md
    //     guide.md
    //   .config/
    //     settings.json

    let files = [
        "file1.txt",
        "file2.txt",
        "file3.md",
        ".hidden.txt",
        "src/main.swift",
        "src/test.swift",
        "src/util.swift",
        "docs/readme.md",
        "docs/guide.md",
        ".config/settings.json",
    ]

    for file in files {
        let fullPath = directory + "/" + file
        let dirPath = parentDirectory(of: fullPath)

        // Create parent directory if needed
        mkdir(dirPath, 0o755)

        // Create file
        let fd = open(fullPath, O_CREAT | O_WRONLY, 0o644)
        if fd >= 0 {
            close(fd)
        }
    }
}

// MARK: - Basic Match Tests

extension Glob.Test.Unit {
    @Test
    func `Match simple wildcard pattern`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("*.txt")
            let results = try Glob.match(pattern: pattern, in: dir)

            #expect(results.count == 2)
            #expect(results.contains(dir + "/file1.txt"))
            #expect(results.contains(dir + "/file2.txt"))
        }
    }

    @Test
    func `Match question mark wildcard`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("file?.txt")
            let results = try Glob.match(pattern: pattern, in: dir)

            #expect(results.count == 2)
            #expect(results.contains(dir + "/file1.txt"))
            #expect(results.contains(dir + "/file2.txt"))
        }
    }

    @Test
    func `Match literal pattern`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("file1.txt")
            let results = try Glob.match(pattern: pattern, in: dir)

            #expect(results.count == 1)
            #expect(results.contains(dir + "/file1.txt"))
        }
    }

    @Test
    func `Match with path segments`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("src/*.swift")
            let results = try Glob.match(pattern: pattern, in: dir)

            #expect(results.count == 3)
            #expect(results.contains(dir + "/src/main.swift"))
            #expect(results.contains(dir + "/src/test.swift"))
            #expect(results.contains(dir + "/src/util.swift"))
        }
    }

    @Test
    func `Match returns empty for no matches`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("*.xyz")
            let results = try Glob.match(pattern: pattern, in: dir)

            #expect(results.isEmpty)
        }
    }
}

// MARK: - Double Star Tests

extension Glob.Test.Unit {
    @Test
    func `Match double star recursive`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("**/*.swift")
            let results = try Glob.match(pattern: pattern, in: dir)

            #expect(results.count == 3)
            #expect(results.contains(dir + "/src/main.swift"))
            #expect(results.contains(dir + "/src/test.swift"))
            #expect(results.contains(dir + "/src/util.swift"))
        }
    }

    @Test
    func `Match double star finds all md files`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("**/*.md")
            let results = try Glob.match(pattern: pattern, in: dir)

            #expect(results.count == 3)
            #expect(results.contains(dir + "/file3.md"))
            #expect(results.contains(dir + "/docs/readme.md"))
            #expect(results.contains(dir + "/docs/guide.md"))
        }
    }
}

// MARK: - Character Class Tests

extension Glob.Test.Unit {
    @Test
    func `Match character class`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("file[12].txt")
            let results = try Glob.match(pattern: pattern, in: dir)

            #expect(results.count == 2)
            #expect(results.contains(dir + "/file1.txt"))
            #expect(results.contains(dir + "/file2.txt"))
        }
    }
}

// MARK: - Options Tests

extension Glob.Test.Unit {
    @Test
    func `Dotfiles explicit policy excludes hidden files`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("*.txt")
            let options = Glob.Options(dotfiles: .explicit)
            let results = try Glob.match(pattern: pattern, in: dir, options: options)

            // Should not include .hidden.txt
            #expect(results.count == 2)
            #expect(!results.contains(dir + "/.hidden.txt"))
        }
    }

    @Test
    func `Dotfiles always policy includes hidden files`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("*.txt")
            let options = Glob.Options(dotfiles: .always)
            let results = try Glob.match(pattern: pattern, in: dir, options: options)

            // Should include .hidden.txt
            #expect(results.count == 3)
            #expect(results.contains(dir + "/.hidden.txt"))
        }
    }

    @Test
    func `Dotfiles never policy excludes hidden files`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern(".*")
            let options = Glob.Options(dotfiles: .never)
            let results = try Glob.match(pattern: pattern, in: dir, options: options)

            // Should not match any dotfiles
            #expect(results.isEmpty)
        }
    }

    @Test
    func `Explicit dotfile pattern matches hidden files`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern(".*.txt")
            let options = Glob.Options(dotfiles: .explicit)
            let results = try Glob.match(pattern: pattern, in: dir, options: options)

            // Explicit .* should match dotfiles
            #expect(results.count == 1)
            #expect(results.contains(dir + "/.hidden.txt"))
        }
    }

    @Test
    func `Deterministic ordering sorts results`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("*.txt")
            let options = Glob.Options(ordering: .deterministic)
            let results = try Glob.match(pattern: pattern, in: dir, options: options)

            // Results should be sorted
            #expect(results == results.sorted())
        }
    }

    @Test
    func `Case insensitive matching`() throws {
        try withTestDirectory { dir in
            // Create a file with uppercase
            let upperPath = dir + "/FILE.TXT"
            let fd = open(upperPath, O_CREAT | O_WRONLY, 0o644)
            if fd >= 0 { close(fd) }

            let pattern = try Glob.Pattern("*.txt")
            let options = Glob.Options(caseInsensitive: true)
            let results = try Glob.match(pattern: pattern, in: dir, options: options)

            // Should match FILE.TXT with *.txt
            #expect(results.contains(upperPath))
        }
    }
}

// MARK: - Include/Exclude Tests

extension Glob.Test.Unit {
    @Test
    func `Match with exclusion pattern`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let include = [try Glob.Pattern("*.txt")]
            let exclude = [try Glob.Pattern("file1.txt")]
            let results = try Glob.match(
                include: include,
                excluding: exclude,
                in: dir
            )

            #expect(results.count == 1)
            #expect(results.contains(dir + "/file2.txt"))
            #expect(!results.contains(dir + "/file1.txt"))
        }
    }

    @Test
    func `Exclude pattern handles directory names containing spaces`() throws {
        // Reproducer for the workaround at swift-linter/Sources/Linter Core/
        // Lint.Source.Walker.swift `pathExclusionSubstrings: [".docc/"]`.
        // Directories like `Carrier Primitives.docc/Resources/step-01.swift`
        // (DocC tutorial step-files inside a SwiftPM `Sources/<Module>.docc/`
        // catalog whose name contains a space) MUST be excluded by the
        // `**/*.docc/**` exclude pattern. Pre-fix behavior: the exclude
        // matched zero entries when the parent dir name had a space, so
        // step-files leaked into the include set.
        try withTestDirectory { dir in
            // Create a SwiftPM-like Sources/<Module>/<Module>.docc/Resources/ tree
            // where the .docc directory's name contains a space.
            let docDir = dir + "/Sources/Foo/Foo Module.docc/Resources"
            mkdir(dir + "/Sources", 0o755)
            mkdir(dir + "/Sources/Foo", 0o755)
            mkdir(dir + "/Sources/Foo/Foo Module.docc", 0o755)
            mkdir(docDir, 0o755)

            // A regular Swift source (should be included).
            let mainFile = dir + "/Sources/Foo/Main.swift"
            close(open(mainFile, O_CREAT | O_WRONLY, 0o644))

            // A docc step-file (should be excluded by **/*.docc/**).
            let stepFile = docDir + "/step-01-imports.swift"
            close(open(stepFile, O_CREAT | O_WRONLY, 0o644))

            let include = [try Glob.Pattern("**/*.swift")]
            let exclude = [try Glob.Pattern("**/*.docc/**")]
            let results = try Glob.match(
                include: include,
                excluding: exclude,
                in: dir
            )

            #expect(results.contains(mainFile), "Main.swift outside .docc must be included")
            #expect(!results.contains(stepFile), "step-01-imports.swift inside `Foo Module.docc/Resources` must be excluded by **/*.docc/**")
        }
    }

    @Test
    func `Exclude pattern with trailing doublestar excludes files inside (no space control)`() throws {
        // Control variant of the spaces test — same shape but the parent dir
        // name has NO space. If this also fails, the bug is doubleStar
        // ignoring files; if only the space variant fails, the bug is in
        // entry-name handling.
        try withTestDirectory { dir in
            let docDir = dir + "/Sources/Foo/Foo.docc/Resources"
            mkdir(dir + "/Sources", 0o755)
            mkdir(dir + "/Sources/Foo", 0o755)
            mkdir(dir + "/Sources/Foo/Foo.docc", 0o755)
            mkdir(docDir, 0o755)

            let stepFile = docDir + "/step-01-imports.swift"
            close(open(stepFile, O_CREAT | O_WRONLY, 0o644))

            let include = [try Glob.Pattern("**/*.swift")]
            let exclude = [try Glob.Pattern("**/*.docc/**")]
            let results = try Glob.match(
                include: include,
                excluding: exclude,
                in: dir
            )

            #expect(!results.contains(stepFile), "step-01-imports.swift inside `Foo.docc/Resources` must be excluded by **/*.docc/**")
        }
    }

    @Test
    func `Match with multiple include patterns`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let include = [
                try Glob.Pattern("*.txt"),
                try Glob.Pattern("*.md")
            ]
            let results = try Glob.match(include: include, in: dir)

            #expect(results.count == 3)
            #expect(results.contains(dir + "/file1.txt"))
            #expect(results.contains(dir + "/file2.txt"))
            #expect(results.contains(dir + "/file3.md"))
        }
    }
}

// MARK: - Error Tests

extension Glob.Test.Unit {
    @Test
    func `Match non-existent directory throws notFound`() throws {
        let pattern = try Glob.Pattern("*.txt")

        #expect(throws: Glob.Error.self) {
            _ = try Glob.match(
                pattern: pattern,
                in: "/nonexistent/path/that/does/not/exist"
            )
        }
    }

    @Test
    func `Match with skip error policy continues on error`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            // Create a directory we can't read
            let restrictedDir = dir + "/restricted"
            mkdir(restrictedDir, 0o000)
            defer { chmod(restrictedDir, 0o755) }

            let pattern = try Glob.Pattern("**/*.txt")
            let options = Glob.Options(onError: .skip)

            // Should not throw, just skip the restricted directory
            let results = try Glob.match(pattern: pattern, in: dir, options: options)
            #expect(results.count >= 2) // At least the root txt files
        }
    }
}

// MARK: - Edge Cases

extension Glob.Test.EdgeCase {
    @Test
    func `Match empty pattern`() throws {
        try withTestDirectory { dir in
            let pattern = try Glob.Pattern("")
            let results = try Glob.match(pattern: pattern, in: dir)

            // Empty pattern matches the directory itself (possibly with trailing /)
            #expect(results.count == 1)
            let result = results[0]
            #expect(result == dir || result == dir + "/")
        }
    }

    @Test
    func `Match pattern with only star`() throws {
        try withTestDirectory { dir in
            try createTestFiles(in: dir)

            let pattern = try Glob.Pattern("*")
            let results = try Glob.match(pattern: pattern, in: dir)

            // Should match all non-hidden files and directories at root
            #expect(results.count >= 4) // file1.txt, file2.txt, file3.md, src/, docs/
        }
    }
}

#endif
