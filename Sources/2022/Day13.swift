import Foundation

public struct Day13: Runnable {

    public struct Result: CustomStringConvertible {
        let part1: Int
        let part2: Int

        public var description: String {
            """
            Part 1: \(part1)
            Part 2: \(part2)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let input = try readFile("day13-input", withExtension: "txt")

        let packets = input
            .split(whereSeparator: \.isNewline)
            .map {
                var copy = $0.dropFirst().dropLast()
                return parsePacketItems(&copy)
            }

        let sumOfCorrectOrdered = packets
            .chunked(into: 2)
            .map { $0.first!.compare($0.last!) }
            .enumerated()
            .filter { $0.element == .orderedAscending }
            .map { $0.offset + 1 }
            .reduce(0, +)


        let dividerPacket1 = [PacketItem.list([PacketItem.single(2)])]
        let dividerPacket2 = [PacketItem.list([PacketItem.single(6)])]
        let orderedPackets = packets
            .appending(contentsOf: [dividerPacket1, dividerPacket2])
            .sorted(by: <)
        let decoderKey = orderedPackets
            .enumerated()
            .filter { $0.element == dividerPacket1 || $0.element == dividerPacket2 }
            .map { $0.offset + 1 }
            .reduce(1, *)

        return Result(
            part1: sumOfCorrectOrdered,
            part2: decoderKey
        )
    }
}

public enum PacketItem: CustomStringConvertible, Equatable {
    case single(Int)
    case list([PacketItem])
    
    public var description: String {
        var descriptionItems = [String]()
        switch self {
        case let .single(int):
            descriptionItems.append("\(int)")

        case let .list(items):
            let listDescription = items.map(\.description).joined(separator: ", ")
            descriptionItems.append("[\(listDescription)]")
        }

        return descriptionItems.joined(separator: ",")
    }
    
    func compare(_ other: PacketItem) -> ComparisonResult {
        switch (self, other) {
        case (.single(let lhsInt), .single(let rhsInt)):
            if lhsInt < rhsInt { return .orderedAscending }
            else if lhsInt > rhsInt { return .orderedDescending }
            return .orderedSame

        case (.list(let lhsList), .list(let rhsList)):
            return lhsList.compare(rhsList)

        case (.single, .list):
            return PacketItem.list([self]).compare(other)

        case (.list, .single):
            return self.compare(.list([other]))
        }
    }
}

extension Array: Comparable where Element == PacketItem {
    func compare(_ other: [PacketItem]) -> ComparisonResult {
        var lhs = self
        var rhs = other
        while let lhsItem = lhs.first {
            guard let rhsItem = rhs.first else {
                return .orderedDescending
            }
            lhs.removeFirst()
            rhs.removeFirst()
            let result = lhsItem.compare(rhsItem)
            if result != .orderedSame {
                return result
            }
        }
        if !rhs.isEmpty {
            return .orderedAscending
        } else {
            return .orderedSame
        }
    }

    public static func < (lhs: Array<Element>, rhs: Array<Element>) -> Bool {
        lhs.compare(rhs) == .orderedAscending
    }
}

private func parsePacketItems(_ input: inout Substring) -> [PacketItem] {
    var number = ""
    var items: [PacketItem] = []
    while let char = input.first {
        input.removeFirst()
        if char.isWholeNumber {
            number += String(char)
        } else {
            if let int = number.intValue {
                items.append(.single(int))
                number = ""
            }
            if char == "[" {
                items.append(.list(parsePacketItems(&input)))
            }
            if char == "]" {
                if let int = number.intValue {
                    items.append(.single(int))
                }
                return items
            }
        }
    }
    if let int = number.intValue {
        items.append(.single(int))
    }
    return items
}

private extension String {
    var intValue: Int? {
        var value: Int?
        let numberString = String(self.reversed())
        for index in numberString.indices {
            guard let number = numberString[index].wholeNumberValue else {
                return nil
            }
            let pos = numberString.distance(
                from: numberString.startIndex,
                to: index
            )
            value = (value ?? 0) + Int(pow(Double(10), Double(pos))) * number
        }
        return value
    }
}
