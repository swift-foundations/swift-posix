public import ISO_9945_Kernel_File

extension POSIX.Kernel.File {

    public enum Move {}
}

extension POSIX.Kernel.File.Move {

    public typealias Error = ISO_9945.Kernel.File.Move.Error
}

extension POSIX.Kernel.File.Move {

    @inlinable
    public static func move(
        from oldPath: borrowing Path.Borrowed,
        to newPath: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.File.Move.Error) {
        while true {
            do throws(ISO_9945.Kernel.File.Move.Error) {
                try ISO_9945.Kernel.File.Move.move(from: oldPath, to: newPath)
                return
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

    @unsafe
    @inlinable
    public static func move(
        from oldPath: UnsafePointer<Path.Char>,
        to newPath: UnsafePointer<Path.Char>
    ) throws(ISO_9945.Kernel.File.Move.Error) {
        while true {
            do throws(ISO_9945.Kernel.File.Move.Error) {
                try unsafe ISO_9945.Kernel.File.Move.move(from: oldPath, to: newPath)
                return
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
    public static func move(
        from oldDescriptor: borrowing ISO_9945.Kernel.Descriptor,
        oldPath: UnsafePointer<Path.Char>,
        to newDescriptor: borrowing ISO_9945.Kernel.Descriptor,
        newPath: UnsafePointer<Path.Char>
    ) throws(ISO_9945.Kernel.File.Move.Error) {
        while true {
            do throws(ISO_9945.Kernel.File.Move.Error) {
                try unsafe ISO_9945.Kernel.File.Move.move(
                    from: oldDescriptor,
                    oldPath: oldPath,
                    to: newDescriptor,
                    newPath: newPath
                )
                return
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
