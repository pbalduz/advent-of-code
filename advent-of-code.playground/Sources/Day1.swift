import Foundation

public struct Day1: Runnable {

    public struct Result: CustomStringConvertible {
        let maximum: Int
        let top3Total: Int

        public var description: String {
            "Maximum: \(maximum) | Top 3 total: \(top3Total)"
        }
    }

    public init() { }

    public func run() throws -> Result {
        let content = try readFile("day1-input", withExtension: "txt")

        let arrayWithTotals = content
            .components(separatedBy: "\n\n")
            .map { $0.components(separatedBy: "\n") }
            .map { $0.compactMap(Int.init) }
            .map { $0.reduce(0, +) }
            .sorted(by: >)

        let top3Total = arrayWithTotals[...2]
            .reduce(0, +)

        return Result(
            maximum: arrayWithTotals.first ?? 0,
            top3Total: top3Total
        )
    }
}
