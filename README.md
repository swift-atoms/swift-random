# swift-random

Use this package when you need to name a source of random bytes without depending on any particular platform: accept or conform to `Random.Generator`, and report its failures as `Random.Error`. It holds only the vocabulary; it ships no generator and reads no entropy, so a concrete source comes from a platform package that conforms to `Random.Generator`.
