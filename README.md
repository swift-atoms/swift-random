# swift-random

Use this package when you need to name a source of random bytes without depending on any particular platform: accept or conform to `Random.Generator`, and report its failures as `Random.Error`. It ships no generator and reads no entropy, so a concrete source comes from a platform package that conforms to `Random.Generator`. To turn a standard library `RandomNumberGenerator` into a fraction whose value is fixed by the generator's output on every platform, use `unit(as:)`.

## Laws

- `unit(as:)` on any `RandomNumberGenerator`, for a `BinaryFloatingPoint` type whose significand holds p bits counting the implicit one (p at most 64), is `next() >> (64 − p)` times 2⁻ᵖ: the top p bits of one value as a share of one, `Double(next() >> 11) * 0x1p-53` for `Double`. It lies in [0, 1), every multiple of 2⁻ᵖ there is equally likely and exact, it takes exactly one value from the generator, and a seeded generator gives the same draws on every platform.
