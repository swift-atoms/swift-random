import Random
import Testing

extension Random.Error {
    enum Test {
        @Suite struct `Random errors preserve their cases codes and checked conformances` {}
        @Suite struct `No additional random error edge cases are defined` {}
        @Suite struct `No random error integration cases are defined` {}
        @Suite(.serialized) struct `No random error performance cases are defined` {}
    }
}

extension Random.Error.Test.`Random errors preserve their cases codes and checked conformances` {
    @Test
    func `entropyNotReady case exists`() {
        let error = Random.Error.entropyNotReady
        _ = error
    }

    @Test
    func `systemError case holds error code`() {
        let error = Random.Error.systemError(42)
        if case .systemError(let code) = error {
            #expect(code == 42)
        } else {
            Issue.record("Expected systemError case")
        }
    }

    @Test
    func `Random errors conform to the Swift error protocol`() {
        let error: any Swift.Error = Random.Error.entropyNotReady
        _ = error
    }

    @Test
    func `Random errors conform to Sendable`() {
        let error: any Sendable = Random.Error.entropyNotReady
        _ = error
    }

    @Test
    func `Hashing distinguishes random error cases and codes`() {
        var set = Set<Random.Error>()
        set.insert(.entropyNotReady)
        set.insert(.systemError(1))
        set.insert(.systemError(2))
        #expect(set.count == 3)
    }

    @Test
    func `Equal errors are equal`() {
        #expect(Random.Error.entropyNotReady == Random.Error.entropyNotReady)
        #expect(Random.Error.systemError(42) == Random.Error.systemError(42))
    }

    @Test
    func `Different errors are not equal`() {
        #expect(Random.Error.entropyNotReady != Random.Error.systemError(0))
        #expect(Random.Error.systemError(1) != Random.Error.systemError(2))
    }
}
