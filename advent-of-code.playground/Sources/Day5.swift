import Foundation

public struct Day5: Runnable {

    public struct Result: CustomStringConvertible {
        let stack1TopCrates: String
        let stack2TopCrates: String

        public var description: String {
            """
            Stack 1 top crates: \(stack1TopCrates)
            Stack 2 top crates: \(stack2TopCrates)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let content = try readFile("day5-input", withExtension: "txt")
            .components(separatedBy: "\n\n")

        let stacksDict = content
            .first!
            .components(separatedBy: "\n")
            .reversed()
            .reduce(into: [Int: String]()) { result, line in
                for (offset, char) in line.enumerated() {
                    guard char.isUppercase else { continue }
                    let absolutePosition = offset / 4 + 1
                    result[absolutePosition, default: ""].append(char)
                }
            }

        let rearrangements = content
            .last!
            .components(separatedBy: "\n")
            .map(Rearrangement.init)

        var stack1 = stacksDict

        for rearrangement in rearrangements {
            rearrangement.applySimpleArrange(to: &stack1)
        }

        var stack2 = stacksDict

        for rearrangement in rearrangements {
            rearrangement.applyBlockArrange(to: &stack2)
        }

        return Result(
            stack1TopCrates: stack1.topOrderedValues,
            stack2TopCrates: stack2.topOrderedValues
        )
    }
}

struct Rearrangement {
    let origin: Int
    let destination: Int
    let count: Int

    init(_ rearrangement: String) {
        let data = rearrangement.split(whereSeparator: { !$0.isNumber })
        origin = Int(String(data[1])) ?? 0
        destination = Int(String(data[2])) ?? 0
        count = Int(String(data[0])) ?? 0
    }

    func applySimpleArrange(to stack: inout Dictionary<Int, String>) {
        for _ in 0 ..< count {
            if let item = stack[origin]?.popLast() {
                stack[destination]?.append(item)
            }
        }
    }

    func applyBlockArrange(to stack: inout Dictionary<Int, String>) {
        if let items = stack[origin]?.suffix(count) {
            stack[destination]?.append(contentsOf: items)
            stack[origin]?.removeLast(count)
        }
    }
}

extension Dictionary where Key: Comparable, Value == String {
    var topOrderedValues: String {
        keys
        .sorted(by: <)
        .compactMap { self[$0]?.last.map(String.init) }
        .joined()
    }
}
