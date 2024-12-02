import Core
import Parsing

public struct Day01: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }
    
    public func part1() async throws -> Int {
        let pairs = try pairList.parse(data)
        let list1 = pairs.map(\.first).sorted()
        let list2 = pairs.map(\.second).sorted()
        return zip(list1, list2).reduce(0) {
            let a = $0 + abs($1.0 - $1.1)
            print(a)
            return a
        }
    }

    public func part2() async throws -> Int {
        let pairs = try pairList.parse(data)
        let list1 = pairs.map(\.first)
        let list2Occurrences = pairs
            .map(\.second)
            .occurrences()

        return list1.reduce(0) {
            $0 + $1 * (list2Occurrences[$1] ?? .zero)
        }
    }
}

private let pair = Parse(
    input: Substring.self,
    Pair.init(first:second:)
) {
    Int.parser()
    "   "
    Int.parser()
}

private let pairList = Many {
    pair
} separator: {
    "\n"
}
