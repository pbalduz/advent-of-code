import Foundation

public struct Day4: Runnable {

    public struct Result: CustomStringConvertible {
        let fullOverlapsCount: Int
        let partialOverlapsCount: Int

        public var description: String {
            """
            Full overlaps count: \(fullOverlapsCount)
            Partial overlaps count: \(partialOverlapsCount)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let content = try readFile("day4-input", withExtension: "txt")

        let assignmentPairs = content
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: ",").map(Assignment.init) }

        let fullOverlapsCount = assignmentPairs
            .filter { $0.first!.contains($0.last!) || $0.last!.contains($0.first!) }
            .count

        let partialOverlapsCount = assignmentPairs
            .filter { $0.first!.overlaps($0.last!) }
            .count

        return Result(
            fullOverlapsCount: fullOverlapsCount,
            partialOverlapsCount: partialOverlapsCount
        )
    }
}

struct Assignment {

    let sections: ClosedRange<Int>

    init(_ string: String) {
        let bounds = string
            .components(separatedBy: "-")
            .compactMap(Int.init)
        let lowerBound = bounds.first ?? 0
        let upperBound = bounds.last ?? 0

        sections = lowerBound...upperBound
    }

    func contains(_ other: Assignment) -> Bool {
        other.sections.first! >= sections.first! && other.sections.last! <= sections.last!
    }

    func overlaps(_ other: Assignment) -> Bool {
        sections.overlaps(other.sections)
    }
}
