# swift-random

A small, Foundation-free vocabulary for cryptographically secure random byte generation.

`swift-random` defines the protocol shared by random-byte generators and the typed failures they can report. Concrete generators remain owned by platform-specific packages.

## Installation

Add the package from its canonical home:

```swift
dependencies: [
    .package(
        url: "https://github.com/swift-atoms/swift-random.git",
        branch: "main"
    )
]
```

Then depend on the narrowest product your target needs:

```swift
.product(name: "Random", package: "swift-random")
```

## Core

The `Random` product provides `Random.Generator` and `Random.Error` without platform or package dependencies:

```swift
import Random

struct RepeatingGenerator: Random.Generator {
    var byte: UInt8

    mutating func fill(
        _ buffer: UnsafeMutableRawBufferPointer
    ) throws(Random.Error) {
        guard let baseAddress = buffer.baseAddress else { return }
        for index in buffer.indices {
            unsafe baseAddress.storeBytes(
                of: byte,
                toByteOffset: index,
                as: UInt8.self
            )
        }
    }
}

var generator = RepeatingGenerator(byte: 0xAB)
var bytes = [UInt8](repeating: 0, count: 32)
try bytes.withUnsafeMutableBytes { buffer in
    try unsafe generator.fill(buffer)
}
```

The mutating requirement permits stateful generators. Typed throws restrict failures to `Random.Error`, whose cases distinguish unavailable entropy from a raw platform error code.

## Products

- `Random` — the Foundation-free generator protocol, error type, and namespace.
- `Random Standard Library Integration` — the standard-library integration and compatibility re-export seam.
- `Random Apple Foundation Integration` — the Apple Foundation integration seam; this is the only product that imports Foundation.

The package has no external dependencies. Its core and standard-library integration are suitable for Embedded-oriented consumers; platform implementations choose the system entropy source.

## License

See [LICENSE.md](LICENSE.md).
