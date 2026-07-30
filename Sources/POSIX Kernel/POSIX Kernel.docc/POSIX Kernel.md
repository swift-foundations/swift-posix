# ``POSIX_Kernel``

@Metadata {
    @DisplayName("POSIX Kernel")
    @TitleHeading("Swift Foundations")
}

Typed Swift wrappers over the POSIX kernel operations shared by Darwin and
Linux — descriptors, files, directories, sockets, locks, polling, process,
thread, signal, environment, clock, time, identity, glob, and terminal — one
target per subsystem, re-exported together as the `POSIX Kernel` umbrella
product.

## When to use this

Reach for this package when code needs a POSIX syscall wrapper that behaves
identically on Darwin and Linux — it hosts only the operations implemented on
both platforms (`fdatasync`, for example, is POSIX-specified but Darwin does
not implement it, so that policy lives in `swift-linux` instead). Platform
divergence within an operation that is nominally shared, or an operation
implemented on only one platform, is completed by `swift-darwin` or
`swift-linux` rather than here. Code that needs only the cross-platform POSIX
names, without an implementation, should depend on `swift-iso-9945` directly.

## Topics

### Related packages

- [swift-iso-9945](https://github.com/swift-iso/swift-iso-9945) — the
  cross-platform POSIX kernel spec this package implements.
- [swift-darwin](https://github.com/swift-foundations/swift-darwin) — the
  Darwin-specific completion for operations this package does not cover.
- [swift-linux](https://github.com/swift-foundations/swift-linux) — the
  Linux-specific completion for operations this package does not cover.
