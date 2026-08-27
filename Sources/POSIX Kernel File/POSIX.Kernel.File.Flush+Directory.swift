@_spi(Syscall) public import ISO_9945_Kernel_File
public import Path

extension POSIX.Kernel.File.Flush {

    @inlinable
    public static func directory(
        path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.File.Flush.Error) {
        let fd: ISO_9945.Kernel.Descriptor
        do throws(ISO_9945.Kernel.File.Open.Error) {
            fd = try _openForDirectoryFlush(path: path)
        } catch {

            switch error {
            case .handle(let e): throw .handle(e)
            case .path: throw .platform(Error.Error(code: .POSIX.ENOENT))
            case .platform(let e): throw .platform(e)
            }
        }
        try flush(fd)

    }

    @inlinable
    package static func _openForDirectoryFlush(
        path: borrowing Path.Borrowed
    ) throws(ISO_9945.Kernel.File.Open.Error) -> ISO_9945.Kernel.Descriptor {
        while true {
            do throws(ISO_9945.Kernel.File.Open.Error) {
                return try ISO_9945.Kernel.File.Open.open(
                    path: path,
                    mode: .read,
                    options: [.execClose],
                    permissions: .none
                )
            } catch {
                if case .platform(let e) = error, e.code.isInterrupted {
                    continue
                }
                throw error
            }
        }
    }
}
