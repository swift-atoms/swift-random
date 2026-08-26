extension Random {

    public enum Error: Swift.Error, Sendable, Hashable {

        case entropyNotReady

        case systemError(Int32)
    }
}
