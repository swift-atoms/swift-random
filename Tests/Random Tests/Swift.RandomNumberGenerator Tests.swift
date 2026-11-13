import Random
import Testing

private struct Listed: Swift.RandomNumberGenerator {
    var values: [UInt64]

    mutating func next() -> UInt64 { values.removeFirst() }
}

private struct Mixer: Swift.RandomNumberGenerator {
    var state: UInt64

    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}

@Suite
struct `Swift.RandomNumberGenerator Tests` {
    @Test
    func `A unit draw is the top 53 bits as a share of one`() {
        var generator = Listed(values: [0, .max, 1 << 63, 0x7FF, 0x800, 0x0123_4567_89AB_CDEF])
        #expect(generator.unit(as: Double.self) == 0)
        #expect(generator.unit(as: Double.self) == 1 - 0x1p-53)
        #expect(generator.unit(as: Double.self) == 0.5)
        #expect(generator.unit(as: Double.self) == 0)
        #expect(generator.unit(as: Double.self) == 0x1p-53)
        #expect(generator.unit(as: Double.self) == Double(UInt64(0x0123_4567_89AB_CDEF) >> 11) / 9_007_199_254_740_992)
        #expect(generator.values.isEmpty)
    }

    @Test
    func `A unit draw is the same as the shift and scale it names, and lies in [0, 1)`() {
        var generator = Mixer(state: 42)
        var copy = generator
        for _ in 0..<10_000 {
            let draw = generator.unit(as: Double.self)
            #expect(draw == Double(copy.next() >> 11) * 0x1p-53)
            #expect(draw >= 0 && draw < 1)
        }
    }

    @Test
    func `A unit draw of a Float is the top 24 bits as a share of one`() {
        var generator = Listed(values: [0, .max, 1 << 63, 0xFF_FFFF_FFFF, 0x100_0000_0000])
        #expect(generator.unit(as: Float.self) == 0)
        #expect(generator.unit(as: Float.self) == 1 - 0x1p-24)
        #expect(generator.unit(as: Float.self) == 0.5)
        #expect(generator.unit(as: Float.self) == 0)
        #expect(generator.unit(as: Float.self) == 0x1p-24)
        #expect(generator.values.isEmpty)
    }

    @Test
    func `A unit draw takes its type from the context`() {
        var generator = Listed(values: [1 << 62, 1 << 62])
        let double: Double = generator.unit()
        let float: Float = generator.unit()
        #expect(double == 0.25 && float == 0.25)
    }
}
