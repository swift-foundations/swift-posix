public import ISO_9945_Kernel_File

extension POSIX.Kernel.File {

    public enum Open {}
}

extension POSIX.Kernel.File.Open {

    public typealias Error = ISO_9945.Kernel.File.Open.Error

    public typealias Mode = ISO_9945.Kernel.File.Open.Mode

    public typealias Options = ISO_9945.Kernel.File.Open.Options
}

extension POSIX.Kernel.File.Open {

    public static func open(
        path: borrowing Path.Borrowed,
        mode: ISO_9945.Kernel.File.Open.Mode,
        options: ISO_9945.Kernel.File.Open.Options,
        permissions: ISO_9945.Kernel.File.Permissions
    ) throws(ISO_9945.Kernel.File.Open.Error) -> ISO_9945.Kernel.Descriptor {
        while true {
            do throws(ISO_9945.Kernel.File.Open.Error) {
                return try ISO_9945.Kernel.File.Open.open(
                    path: path,
                    mode: mode,
                    options: options,
                    permissions: permissions
                )
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
