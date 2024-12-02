import Core

public struct Day07: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() -> Any {
        computeWinnings(by: Hand.compare)
    }

    public func part2() -> Any {
        computeWinnings(by: Hand.compareWithJokers)
    }

    private func computeWinnings(by sorting: (Hand, Hand) -> Bool) -> Int {
        let hands = data
            .lines
            .map { $0.components(separatedBy: " ") }
            .filter { !$0.contains(where: { $0.isEmpty })}
            .map {
                Hand(
                    bid: Int($0[1])!,
                    cards: $0[0].map { Card(rawValue: .init($0))! }
                )
            }
            .sorted(by: sorting)

        return zip(1...hands.count, hands)
            .map { $0 * $1.bid }
            .reduce(0, +)
    }
}

private enum Card: String, CaseIterable {
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case T
    case J
    case Q
    case K
    case A

    var rank: Int {
        zip(1...Self.allCases.count, Self.allCases)
            .first { $1 == self }!.0
    }

    var rankWithJokers: Int {
        if self == .J { return 1 }
        let regularRank = rank
        return regularRank > Self.J.rank ? regularRank : regularRank + 1
    }
}

private struct Hand {
    let bid: Int
    let cards: [Card]

    var type: `Type`! {
        let values = cards
            .grouped { $0 }
            .values
            .sorted { $0.count > $1.count }
        switch values.map(\.count) {
        case [5]: return .kind5
        case [4, 1]: return .kind4
        case [3, 2]: return .fullHouse
        case [3, 1, 1]: return .kind3
        case [2, 2, 1]: return .pair2
        case [2, 1, 1, 1]: return .pair1
        case [1, 1, 1, 1, 1]: return .highCard
        default: return nil
        }
    }

    var typeWithJokers: `Type`! {
        let values = cards
            .grouped { $0 }
            .values
            .sorted { $0.count > $1.count }
        let jokersCount = cards.filter { $0 == .J }.count
        switch values.map(\.count) {
        case [5]: return .kind5
        case [4, 1]: return jokersCount > 0 ? .kind5 : .kind4
        case [3, 2]: return jokersCount > 0 ? .kind5 : .fullHouse
        case [3, 1, 1]: return jokersCount > 0 ? .kind4 : .kind3
        case [2, 2, 1]:
            switch jokersCount {
            case 1: return .fullHouse
            case 2: return .kind4
            default: return .pair2
            }
        case [2, 1, 1, 1]: return jokersCount > 0 ? .kind3 : .pair1
        case [1, 1, 1, 1, 1]: return jokersCount > 0 ? .pair1 : .highCard
        default: return nil
        }
    }

    static func compare(lhs: Hand, rhs: Hand) -> Bool {
        let lhsType = lhs.type!
        let rhsType = rhs.type!
        guard lhsType == rhsType else {
            return lhsType.rawValue < rhsType.rawValue
        }
        let cardPair = zip(
            lhs.cards,
            rhs.cards
        ).first { $0 != $1 }!
        return cardPair.0.rank < cardPair.1.rank
    }

    static func compareWithJokers(lhs: Hand, rhs: Hand) -> Bool {
        let lhsType = lhs.typeWithJokers!
        let rhsType = rhs.typeWithJokers!
        guard lhsType == rhsType else {
            return lhsType.rawValue < rhsType.rawValue
        }
        let cardPair = zip(
            lhs.cards,
            rhs.cards
        ).first { $0 != $1 }!
        return cardPair.0.rankWithJokers < cardPair.1.rankWithJokers
    }

    enum `Type`: Int {
        case highCard
        case pair1
        case pair2
        case kind3
        case fullHouse
        case kind4
        case kind5
    }
}

extension String {
    var lines: [String] {
        components(separatedBy: "\n")
    }
}
