import Random
import Testing

private struct MockGenerator: Sendable {
    var fillByte: UInt8

    init(fillByte: UInt8 = 0xAB) {
        self.fillByte = fillByte
    }
}

extension MockGenerator: Random.Generator {
    mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Random.Error) {
        guard let baseAddress = buffer.baseAddress else { return }
        buffer.indices.forEach { i in
            baseAddress.storeBytes(of: fillByte, toByteOffset: i, as: UInt8.self)
        }
    }
}

private struct FailingGenerator: Sendable {
    let error: Random.Error

    init(error: Random.Error = .entropyNotReady) {
        self.error = error
    }
}

extension FailingGenerator: Random.Generator {
    mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Random.Error) {
        throw error
    }
}

@Suite struct `Random generators fill buffers and propagate typed errors` {
    @Suite struct `Random generators preserve filling errors and checked conformances` {}
    @Suite struct `Random generators fill large buffers and permit state mutation` {}
    @Suite struct `No additional random generator integration cases are defined` {}
    @Suite(.serialized) struct `No random generator performance cases are defined` {}
}

extension `Random generators fill buffers and propagate typed errors`.`Random generators preserve filling errors and checked conformances` {
    @Test
    func `Generator protocol can be implemented`() throws {
        var generator = MockGenerator()
        var buffer = [UInt8](repeating: 0, count: 16)
        try buffer.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer.allSatisfy { $0 == 0xAB })
    }

    @Test
    func `Generator handles empty buffer`() throws {
        var generator = MockGenerator()
        var buffer: [UInt8] = []
        try buffer.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer.isEmpty)
    }

    @Test
    func `Generator can throw typed error`() {
        var generator = FailingGenerator(error: .entropyNotReady)
        var buffer = [UInt8](repeating: 0, count: 16)

        #expect(throws: Random.Error.entropyNotReady) {
            try buffer.withUnsafeMutableBytes { ptr in
                try generator.fill(ptr)
            }
        }
    }

    @Test
    func `Generator can throw systemError`() {
        var generator = FailingGenerator(error: .systemError(123))
        var buffer = [UInt8](repeating: 0, count: 16)

        #expect(throws: Random.Error.systemError(123)) {
            try buffer.withUnsafeMutableBytes { ptr in
                try generator.fill(ptr)
            }
        }
    }

    @Test
    func `Generator is Sendable`() {
        let generator: any Random.Generator & Sendable = MockGenerator()
        _ = generator
    }

    @Test
    func `Generator can be used as existential`() throws {
        var generator: any Random.Generator = MockGenerator(fillByte: 0xFF)
        var buffer = [UInt8](repeating: 0, count: 8)
        try buffer.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer.allSatisfy { $0 == 0xFF })
    }
}

extension `Random generators fill buffers and propagate typed errors`.`Random generators fill large buffers and permit state mutation` {
    @Test
    func `Generator fills large buffer`() throws {
        var generator = MockGenerator(fillByte: 0x42)
        var buffer = [UInt8](repeating: 0, count: 1024 * 1024)
        try buffer.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer.allSatisfy { $0 == 0x42 })
    }

    @Test
    func `Generator state can be mutated`() throws {
        var generator = MockGenerator(fillByte: 0x01)

        var buffer1 = [UInt8](repeating: 0, count: 4)
        try buffer1.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer1.allSatisfy { $0 == 0x01 })

        generator.fillByte = 0x02
        var buffer2 = [UInt8](repeating: 0, count: 4)
        try buffer2.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer2.allSatisfy { $0 == 0x02 })
    }
}
