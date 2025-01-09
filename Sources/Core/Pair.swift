public struct Pair<A, B> {
    public let first: A
    public let second: B

    public init(
        first: A,
        second: B
    ) {
        self.first = first
        self.second = second
    }
}

public typealias PairOf<T> = Pair<T, T>
