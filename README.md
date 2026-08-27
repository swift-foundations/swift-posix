# POSIX Kernel

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-compositions/swift-posix/workflows/CI/badge.svg)](https://github.com/swift-compositions/swift-posix/actions/workflows/ci.yml)

Type-safe POSIX syscall wrappers for Swift. Signals, process management, and dynamic library loading with typed throws and full Sendable compliance.

---

## Key Features

- **Typed throws end-to-end** – `Signal.Error`, `Process.Error`, `Library.Dynamic.Error` with semantic accessors
- **Swift 6 strict concurrency** – Full `Sendable` compliance with documented thread-safety guarantees
- **Type-safe signals** – `Signal.Number` constants, `Signal.Set`, `Signal.Mask`, `Signal.Action`
- **Process management** – Fork, exec, wait with type-safe selectors replacing magic values
- **Dynamic loading** – `dlopen`/`dlsym`/`dlclose` with typed handles and scopes
- **Cross-platform** – Darwin, Linux (Glibc, Musl), Windows (dynamic loading only)
- **Policy-free design** – Raw syscall semantics without retry policies; EINTR returned to caller

---

## Installation

### Package.swift dependency

```swift
dependencies: [
    .package(url: "https://github.com/swift-compositions/swift-posix.git", from: "0.1.0")
]
```

### Target dependency

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "POSIX Kernel", package: "swift-posix")
    ]
)
```

### Requirements

- Swift 6.2+
- macOS 26+ / iOS 26+ / tvOS 26+ / watchOS 26+ / Linux

---

## Quick Start

```swift
import POSIX_Kernel

// Fork a child process and wait for it
switch try POSIX.Kernel.Process.Fork.fork() {
case .child:
    // Child process: execute /bin/ls
    "/bin/ls".withCString { path in
        let argv: [UnsafePointer<CChar>?] = [path, nil]
        let envp: [UnsafePointer<CChar>?] = [nil]
        argv.withUnsafeBufferPointer { argvBuf in
            envp.withUnsafeBufferPointer { envpBuf in
                try? POSIX.Kernel.Process.Execute.execve(
                    path: path,
                    argv: argvBuf.baseAddress!,
                    envp: envpBuf.baseAddress!
                )
            }
        }
    }
    POSIX.Kernel.Process.Exit.now(127)  // exec failed

case .parent(let child):
    // Parent process: wait for child
    let result = try POSIX.Kernel.Process.Wait.wait(.process(child))
    if let code = result?.status.exit.code {
        print("Child exited with code: \(code)")
    }
}
```

---

## Architecture

| Type | Description |
|------|-------------|
| `POSIX.Kernel.Signal.Number` | Type-safe signal numbers with named constants |
| `POSIX.Kernel.Signal.Set` | Signal set operations (sigset_t wrapper) |
| `POSIX.Kernel.Signal.Mask` | Thread signal mask control (pthread_sigmask) |
| `POSIX.Kernel.Signal.Action` | Signal handler installation (sigaction) |
| `POSIX.Kernel.Signal.Send` | Signal sending (kill, raise) |
| `POSIX.Kernel.Process.Fork` | Process forking with typed result |
| `POSIX.Kernel.Process.Execute` | execve wrapper |
| `POSIX.Kernel.Process.Wait` | waitpid with typed selectors |
| `POSIX.Kernel.Process.Status` | Exit status interpretation (WIFEXITED, etc.) |
| `POSIX.Kernel.Process.Group` | Process group operations (setpgid, getpgid) |
| `POSIX.Kernel.Process.Session` | Session operations (setsid, getsid) |
| `POSIX.Kernel.Library.Dynamic` | dlopen/dlsym/dlclose with typed handles |

---

## Platform Support

| Platform         | CI  | Status       |
|------------------|-----|--------------|
| macOS            | ✅  | Full support |
| Linux            | ✅  | Full support |
| iOS/tvOS/watchOS | —   | Supported    |
| Windows          | —   | Dynamic loading only |

---

## Error Handling

`POSIX.Kernel.Close` declares this package's own typed error, `POSIX.Kernel.Close.Error`, an `Equatable` enum wrapping the two failure modes of closing a descriptor:

```
POSIX.Kernel.Close.Error
├── handle(POSIX.Kernel.Descriptor.Validity.Error)   // descriptor was not a valid open handle
└── platform(Error.Error)                            // underlying close(2) errno
```

Because it is declared with typed throws, the do/catch is exhaustive with no default branch:

```swift
do throws(POSIX.Kernel.Close.Error) {
    try POSIX.Kernel.Close.close(descriptor)
} catch {
    switch error {
    case .handle(let validity):
        // descriptor did not refer to a valid open handle
        print("invalid descriptor: \(validity)")
    case .platform(let posixError):
        // close(2) reported an errno
        print("close failed: \(posixError)")
    }
}
```

Most other operations in this package surface the lower-layer typed errors they wrap — `ISO_9945.Kernel.Process.Error`, `ISO_9945.Kernel.Signal.Error`, `ISO_9945.Kernel.File.Flush.Error`, `Memory.Lock.Error`, `ISO_9945.Loader.Error`, and `Error.Error` among them — each of which is likewise exhaustively matchable.

---

## Related Packages

### Dependencies

- [swift-kernel](https://github.com/swift-compositions/swift-kernel): Base kernel type and error codes

### Used By

- [swift-kernel](https://github.com/swift-compositions/swift-kernel): Higher-level kernel abstractions

---

## License

This project is licensed under the Apache License v2.0. See [LICENSE.md](LICENSE.md) for details.
