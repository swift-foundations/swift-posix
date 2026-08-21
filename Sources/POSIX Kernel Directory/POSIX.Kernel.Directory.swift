public import ISO_9945_Kernel_Directory

extension POSIX.Kernel {

    public enum Directory: Sendable {}
}

extension POSIX.Kernel.Directory {

    public typealias Error = ISO_9945.Kernel.Directory.Error
}

extension POSIX.Kernel.Directory {

    @unsafe
    @inlinable
    public static func open(
        at path: UnsafePointer<Path.Char>
    ) throws(ISO_9945.Kernel.Directory.Error) -> ISO_9945.Kernel.Directory.Stream {
        while true {
            do throws(ISO_9945.Kernel.Directory.Error) {
                return try unsafe ISO_9945.Kernel.Directory.open(at: path)
            } catch {

                if case .platform(let primitiveError) = error,
                    primitiveError.code.isInterrupted
                {
                    continue
                }
                throw error
            }
        }
    }

    @inlinable
    public static func open(
        at path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.Directory.Error) -> ISO_9945.Kernel.Directory.Stream {
        while true {
            do throws(ISO_9945.Kernel.Directory.Error) {
                return try ISO_9945.Kernel.Directory.open(at: path)
            } catch {
                if case .platform(let primitiveError) = error,
                    primitiveError.code.isInterrupted
                {
                    continue
                }
                throw error
            }
        }
    }
}
