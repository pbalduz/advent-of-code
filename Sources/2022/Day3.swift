import Foundation

public struct Day3: Runnable {

    public struct Result: CustomStringConvertible {
        let commonItemsPriority: Int
        let commonGroupItemsPriority: Int

        public var description: String {
            """
            Common items priority: \(commonItemsPriority)
            Common group items priority: \(commonGroupItemsPriority)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let content = try readFile("day3-input", withExtension: "txt")

        let rucksacks = content
            .components(separatedBy: "\n")
            .map(Rucksack.init)

        let commonItemsPriority = rucksacks
            .compactMap(\.sharedItem)
            .map(\.priority)
            .reduce(0, +)

        let groups = stride(
            from: 0,
            to: rucksacks.count,
            by: 3
        ).map {
            Array(rucksacks[$0..<min($0 + 3, rucksacks.count)])
        }

        let commonGroupItemsPriority = groups
            .map(Group.init)
            .compactMap(\.sharedItem)
            .map(\.priority)
            .reduce(0, +)

        return Result(
            commonItemsPriority: commonItemsPriority,
            commonGroupItemsPriority: commonGroupItemsPriority
        )
    }
}

struct Rucksack {
    let compartiment1: String
    let compartiment2: String

    var sharedItem: Character? {
        for item in compartiment1 {
            if compartiment2.contains(item) {
                return item
            }
        }
        return nil
    }

    init(_ items: String) {
        compartiment1 = String(items.prefix(items.count / 2))
        compartiment2 = String(items.suffix(items.count / 2))
    }
}

struct Group {
    let rucksacks: [Rucksack]

    init(_ rucksacks: [Rucksack]) {
        self.rucksacks = rucksacks
    }

    var sharedItem: Character? {
        let rucksacks = rucksacks
            .map { $0.compartiment1 + $0.compartiment2 }

        let first = rucksacks.first ?? ""
        return rucksacks
            .dropFirst()
            .reduce(Set(first)) { result, element in
                result.intersection(Set(element))
            }
            .first
            .map(Character.init)
    }
}

extension Character {
    public var priority: Int {
        max(
            0,
            Int(asciiValue ?? 0) - (isLowercase ? 96 : 38)
        )
    }
}
