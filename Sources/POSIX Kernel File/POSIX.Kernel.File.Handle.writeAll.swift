// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-posix open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-posix project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

internal import Either_Primitives
internal import ISO_9945_Kernel_File

// MARK: - L3 Handle.writeAll with EINTR surfacing
//
// `ISO_9945.Kernel.File.Handle.writeAll(from:)` lives at L3 per Doc 1 Option 5
// (method-level L2→L3 split; audit findings P2.2 #1 + #11). The partial-IO
// while-loop is L3 policy per [PLAT-ARCH-008e] ("L2 is spec-literal, L3 is
// policy-wrapped"). Each iteration delegates to the raw L2 syscall wrapper
// `ISO_9945.Kernel.IO.Write.write` so signal interruption propagates to
// the caller as `.right(.occurred)` per Doc 1 § Principal Decision #2
// (binding at `d20d91b`): "method surfaces Interrupt for caller;
// free-function retries internally — pick your abstraction." Runtime
// semantics match the (deleted) L2 sibling exactly; intra-family
// consistent with preserved `ISO_9945.Kernel.File.Handle.write(from:)` and
// `.pwrite(from:at:)` which also surface EINTR.
//
// Split-legibility aids per Doc 1 Decision #3:
// - iso-9945 Research note: `file-handle-writeall-l2-l3-split-rationale.md`
// - swift-posix cascade paragraph: `Research/l3-policy-design.md`
// - DocC See-Also in iso-9945 `ISO 9945.Kernel.File.Handle.write.swift`
//   pointing here (landed in Phase 2b).

extension ISO_9945.Kernel.File.Handle {
    /// Writes all bytes to the file, handling partial writes.
    ///
    /// Loops until all bytes are written or an error occurs. Each iteration
    /// invokes the raw L2 syscall wrapper
    /// ``ISO_9945/Kernel/IO/Write/write(_:from:)``; EINTR propagates to
    /// the caller as `.right(.occurred)` rather than being retried
    /// internally. For EINTR-transparent bulk writes on a bare descriptor,
    /// use ``POSIX/Kernel/IO/Write/writeAll(_:from:)`` — the free-function
    /// form retries EINTR internally.
    ///
    /// - Parameter buffer: The buffer to write from.
    /// - Throws: `Either<Error, Interrupt>` — `.left` for domain errors,
    ///   `.right(.occurred)` for EINTR.
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
                // Should not happen for regular files, but handle gracefully.
                throw .left(Self.Error(from: ISO_9945.Kernel.IO.Write.Error.platform(Error_Primitives.Error(code: .POSIX.EIO)), operation: .write))
            }
            written += n
        }
    }
}

// MARK: - Span Adapters

extension ISO_9945.Kernel.File.Handle {
    /// Writes all bytes from a span to the file.
    ///
    /// Delegates to the `UnsafeRawBufferPointer` overload via
    /// ``Span/withUnsafeBytes(_:)``. EINTR propagation semantics are
    /// identical: the caller sees `.right(.occurred)` on signal
    /// interruption.
    ///
    /// - Parameter span: The span containing bytes to write.
    /// - Throws: `Either<Error, Interrupt>` — `.left` for domain errors,
    ///   `.right(.occurred)` for EINTR.
    @inlinable
    public borrowing func writeAll(
        from span: Swift.Span<Byte>
    ) throws(Either<Self.Error, Interrupt>) {
        try unsafe span.withUnsafeBytes {
            (buffer: UnsafeRawBufferPointer) throws(Either<Self.Error, Interrupt>) in
            try unsafe writeAll(from: buffer)
        }
    }
}
