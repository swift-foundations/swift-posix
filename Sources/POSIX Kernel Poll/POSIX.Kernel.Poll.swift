public import ISO_9945_Kernel_Poll
public import POSIX_Kernel_Clock

extension POSIX.Kernel {

    public enum Poll: Sendable {}
}

extension POSIX.Kernel.Poll {

    public typealias Events = ISO_9945.Kernel.Poll.Events

    public typealias Entry = ISO_9945.Kernel.Poll.Entry
}

extension POSIX.Kernel.Poll {

    @inlinable
    public static func poll(
        _ entries: inout [ISO_9945.Kernel.Poll.Entry],
        timeout: Int32
    ) throws(Error.Error) -> Int {

        guard timeout > 0 else {
            while true {
                do throws(Error.Error) {
                    return try ISO_9945.Kernel.Poll.poll(&entries, timeout: timeout)
                } catch  where error.code.isInterrupted {
                    continue
                }
            }
        }

        let start = Clock.Continuous.now
        var remaining = timeout
        while true {
            do throws(Error.Error) {
                return try ISO_9945.Kernel.Poll.poll(&entries, timeout: remaining)
            } catch  where error.code.isInterrupted {
                let elapsedMilliseconds =
                    (Clock.Continuous.now.nanoseconds - start.nanoseconds) / 1_000_000
                guard elapsedMilliseconds < UInt64(timeout) else {
                    return 0
                }
                remaining = timeout - Int32(elapsedMilliseconds)
            }
        }
    }
}
