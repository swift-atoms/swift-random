extension Random {

    public protocol Generator: Sendable {

        mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Random.Error)
    }
}
