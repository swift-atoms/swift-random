extension Swift.RandomNumberGenerator {

    /// A draw from [0, 1): the top bits of the next value, as many as the type's significand holds (at most
    /// 64), as a share of one.
    ///
    /// For a type with a significand of p bits, counting the implicit one, it is `next() >> (64 − p)` times
    /// 2⁻ᵖ: 2⁻⁵³ steps for `Double`, 2⁻²⁴ for `Float`. Every value it can take is a multiple of that step,
    /// each equally likely, and each is exact in the type, so the draw has no rounding and never reaches 1.
    /// It takes one value from the generator, so a seeded generator gives the same draws in the same order
    /// on every platform.
    @inlinable
    public mutating func unit<Value: BinaryFloatingPoint>(as _: Value.Type = Value.self) -> Value {
        let bits = Swift.min(Value.significandBitCount + 1, UInt64.bitWidth)
        let step = Value(sign: .plus, exponent: Value.Exponent(-bits), significand: 1)
        return Value(next() >> UInt64(UInt64.bitWidth - bits)) * step
    }
}
