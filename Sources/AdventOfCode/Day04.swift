import Foundation
import RegexBuilder

struct Day04: AdventDay {
    let data: String

    func part1() -> Any {
        let cards = mapCards(input: data)
        let cardsValues = cards.map { card in
            let winningCount = card.matchingCount
            guard winningCount > 0 else {
                return 0.0
            }
            return pow(
                Double(2),
                Double(winningCount - 1)
            )
        }
        return Int(cardsValues.reduce(0, +))
    }

    func part2() -> Any {
        let cards = mapCards(input: data)
        return cards
            .reduce(into: Array(repeating: 1, count: cards.count)) { result, card in
                let matchingCount = card.matchingCount
                if matchingCount > 0 {
                    for id in (card.id + 1...card.id + matchingCount) {
                        result[id] += result[card.id]
                    }
                }
            }
            .reduce(0, +)
    }
    
    private func mapCards(input: String) -> [Card] {
        input.matches(of: regex)
            .enumerated()
            .map { offset, element in
                let winningNumbers = element.output.1
                    .matches(of: .positiveInt)
                    .reduce(into: Set<Int>()) { result, match in
                        result.insert(match.output.1)
                    }
                let currentNumbers = element.output.2
                    .matches(of: .positiveInt)
                    .reduce(into: Set<Int>()) { result, match in
                        result.insert(match.output.1)
                    }
                return Card(
                    id: offset,
                    winning: winningNumbers,
                    current: currentNumbers
                )
            }
    }
}

private struct Card {
    let id: Int
    let winning: Set<Int>
    let current: Set<Int>
    
    var matchingCount: Int {
        winning.intersection(current).count
    }
}

private let regex = Regex {
    Anchor.startOfLine
    "Card"
    OneOrMore(.whitespace)
    OneOrMore(.digit)
    ": "
    Capture {
        OneOrMore(.any, .reluctant)
    }
    "|"
    Capture {
        OneOrMore(.any, .reluctant)
    }
    Anchor.endOfLine
}
