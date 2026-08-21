internal import Either_Primitives
internal import ISO_9945_Kernel_File

extension ISO_9945.Kernel.File.Handle {

    @inlinable
    public borrowing func writeAll(
        from buffer: UnsafeRawBufferPointer
    ) throws(Either<Self.Error, Interrupt>) {
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
            let n: Int
            do throws(ISO_9945.Kernel.IO.Write.Error) {
                n = try unsafe ISO_9945.Kernel.IO.Write.write(descriptor, from: remaining)
            } catch {
                if error.code.isInterrupted {
                    throw .right(.occurred)
                }
                throw .left(Self.Error(from: error, operation: .write))
            }
            if n == 0 {

                throw .left(
                    Self.Error(
                        from: ISO_9945.Kernel.IO.Write.Error.platform(
                            Error_Primitives.Error(code: .POSIX.EIO)
                        ),
                        operation: .write
                    )
                )
            }
            written += n
        }
    }
}

extension ISO_9945.Kernel.File.Handle {

    @inlinable
    public borrowing func writeAll(
        from span: Swift.Span<Byte>
    ) throws(Either<Self.Error, Interrupt>) {
        try span.withUnsafeBytes {
            (buffer: UnsafeRawBufferPointer) throws(Either<Self.Error, Interrupt>) in
            try unsafe writeAll(from: buffer)
        }
    }
}
