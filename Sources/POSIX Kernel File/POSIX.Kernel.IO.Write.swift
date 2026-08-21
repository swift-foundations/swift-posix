public import ISO_9945_Kernel_File

extension POSIX.Kernel {

    public enum IO {}
}

extension POSIX.Kernel.IO {

    public enum Write {}
}

extension POSIX.Kernel.IO.Write {

    public typealias Error = ISO_9945.Kernel.IO.Write.Error
}

extension POSIX.Kernel.IO.Write {

    @inlinable
    public static func write(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from buffer: UnsafeRawBufferPointer
    ) throws(ISO_9945.Kernel.IO.Write.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.IO.Write.Error) {
                return unsafe try ISO_9945.Kernel.IO.Write.write(descriptor, from: buffer)
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    @inlinable
    public static func pwrite(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from buffer: UnsafeRawBufferPointer,
        at offset: ISO_9945.Kernel.File.Offset
    ) throws(ISO_9945.Kernel.IO.Write.Error) -> Int {
        while true {
            do throws(ISO_9945.Kernel.IO.Write.Error) {
                return unsafe try ISO_9945.Kernel.IO.Write.pwrite(
                    descriptor,
                    from: buffer,
                    at: offset
                )
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }

    @inlinable
    public static func writeAll(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from buffer: UnsafeRawBufferPointer
    ) throws(ISO_9945.Kernel.IO.Write.Error) {
        guard let baseAddress = buffer.baseAddress else {
            return
        }

        var written = 0
        let total = buffer.count

        while written < total {
            let remaining = unsafe UnsafeRawBufferPointer(
                start: baseAddress.advanced(by: written),
                count: total - written
            )
            let n = unsafe try write(descriptor, from: remaining)
            if n == 0 {

                throw .platform(Error_Primitives.Error(code: .POSIX.EIO))
            }
            written += n
        }
    }
}

extension POSIX.Kernel.IO.Write {

    @inlinable
    public static func write(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from span: Swift.Span<Byte>
    ) throws(ISO_9945.Kernel.IO.Write.Error) -> Int {
        try span.withUnsafeBytes { buffer throws(ISO_9945.Kernel.IO.Write.Error) in
            unsafe try write(descriptor, from: buffer)
        }
    }

    @inlinable
    public static func pwrite(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from span: Swift.Span<Byte>,
        at offset: ISO_9945.Kernel.File.Offset
    ) throws(ISO_9945.Kernel.IO.Write.Error) -> Int {
        try span.withUnsafeBytes { buffer throws(ISO_9945.Kernel.IO.Write.Error) in
            unsafe try pwrite(descriptor, from: buffer, at: offset)
        }
    }

    @inlinable
    public static func writeAll(
        _ descriptor: borrowing ISO_9945.Kernel.Descriptor,
        from span: Swift.Span<Byte>
    ) throws(ISO_9945.Kernel.IO.Write.Error) {
        try span.withUnsafeBytes { buffer throws(ISO_9945.Kernel.IO.Write.Error) in
            unsafe try writeAll(descriptor, from: buffer)
        }
    }
}
