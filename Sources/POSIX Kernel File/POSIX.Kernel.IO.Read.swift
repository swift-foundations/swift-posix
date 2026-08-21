public import ISO_9945_Kernel_File

extension POSIX.Kernel.IO {

    public enum Read {}
}

extension POSIX.Kernel.IO.Read {

    public typealias Error = ISO_9945.Kernel.IO.Read.Error
}

extension POSIX.Kernel.IO.Read {

    @inlinable
    public static func read(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        into buffer: UnsafeMutableRawBufferPointer
    ) throws(ISO_9945.Kernel.IO.Read.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.IO.Read.Error) {
                return unsafe try ISO_9945.Kernel.IO.Read.read(descriptor, into: buffer)
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    @inlinable
    public static func pread(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        into buffer: UnsafeMutableRawBufferPointer,
        at offset: ISO_9945.Kernel.File.Offset
    ) throws(ISO_9945.Kernel.IO.Read.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.IO.Read.Error) {
                return unsafe try ISO_9945.Kernel.IO.Read.pread(
                    descriptor,
                    into: buffer,
                    at: offset
                )
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    @inlinable
    public static func readAll(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        into buffer: UnsafeMutableRawBufferPointer
    ) throws(ISO_9945.Kernel.IO.Read.Error) -> Int {
        guard let baseAddress = buffer.baseAddress else {
            return 0
        }

        var totalRead = 0
        let total = buffer.count

        while totalRead < total {
            let remaining = unsafe UnsafeMutableRawBufferPointer(
                start: baseAddress.advanced(by: totalRead),
                count: total - totalRead
            )
            let n = unsafe try read(descriptor, into: remaining)
            if n == 0 {
                break
            }
            totalRead += n
        }
        return totalRead
    }
}

extension POSIX.Kernel.IO.Read {

    @inlinable
    public static func read(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        into output: inout Swift.OutputSpan<Byte>
    ) throws(ISO_9945.Kernel.IO.Read.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.IO.Read.Error) {
                return try ISO_9945.Kernel.IO.Read.read(descriptor, into: &output)
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    @inlinable
    public static func read(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        into span: inout MutableSpan<Byte>
    ) throws(ISO_9945.Kernel.IO.Read.Error) -> Int {
        try span.withUnsafeMutableBytes {
            (buffer: UnsafeMutableRawBufferPointer) throws(ISO_9945.Kernel.IO.Read.Error) -> Int in
            unsafe try read(descriptor, into: buffer)
        }
    }

    @inlinable
    public static func pread(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        into span: inout MutableSpan<Byte>,
        at offset: ISO_9945.Kernel.File.Offset
    ) throws(ISO_9945.Kernel.IO.Read.Error) -> Int {
        try span.withUnsafeMutableBytes {
            (buffer: UnsafeMutableRawBufferPointer) throws(ISO_9945.Kernel.IO.Read.Error) -> Int in
            unsafe try pread(descriptor, into: buffer, at: offset)
        }
    }
}
