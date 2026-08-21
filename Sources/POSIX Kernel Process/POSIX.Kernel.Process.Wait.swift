public import ISO_9945_Kernel_Process

extension POSIX.Kernel.Process {

    public enum Wait: Sendable {}
}

extension POSIX.Kernel.Process.Wait {

    public typealias Kind = ISO_9945.Kernel.Process.Wait.Kind

    public typealias Options = ISO_9945.Kernel.Process.Wait.Options

    public typealias Result = ISO_9945.Kernel.Process.Wait.Result

    public typealias Selector = ISO_9945.Kernel.Process.Wait.Selector
}

extension POSIX.Kernel.Process.Wait {

    @inlinable
    public static func wait(
        _ selector: ISO_9945.Kernel.Process.Wait.Selector,
        options: ISO_9945.Kernel.Process.Wait.Options = []
    ) throws(ISO_9945.Kernel.Process.Error) -> ISO_9945.Kernel.Process.Wait.Result? {
        while true {
            do throws(ISO_9945.Kernel.Process.Error) {
                return try ISO_9945.Kernel.Process.Wait.wait(selector, options: options)
            } catch  where error.code.isInterrupted {
                continue
            }
        }
    }
}
