# swift-random

Use this package when you need to name a source of random bytes without depending on any particular platform: accept or conform to `Random.Generator`, and report its failures as `Random.Error`. It holds only the vocabulary; it ships no generator and reads no entropy, so a concrete source comes from a platform package that conforms to `Random.Generator`.

## Laws

- `unit()` on any `RandomNumberGenerator` is `Double(next() >> 11) * 0x1p-53`: the top 53 bits of one value as a share of one. It lies in [0, 1), every multiple of 2⁻⁵³ there is equally likely and exact, and a seeded generator gives the same draws on every platform.
