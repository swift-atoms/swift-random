extension Swift.RandomNumberGenerator {

    /// A draw from [0, 1): the top 53 bits of the next value as a share of one, `next() >> 11` times 2⁻⁵³.
    ///
    /// Every value it can take is a multiple of 2⁻⁵³, each equally likely, and each is a `Double` exactly,
    /// so the draw has no rounding and never reaches 1. It takes one value from the generator, so a seeded
    /// generator gives the same draws in the same order on every platform.
    @inlinable
    public mutating func unit() -> Double {
        Double(next() >> 11) * 0x1p-53
    }
}
