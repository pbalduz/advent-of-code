import Core
import Parsing

public struct Day05: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        let updates = try SafetyManualParser().parse(data)
        return computeValue(
            updates: updates,
            isIncluded: ==
        )
    }

    public func part2() async throws -> Int {
        let updates = try SafetyManualParser().parse(data)
        return computeValue(
            updates: updates,
            isIncluded: !=
        )
    }

    private func computeValue(
        updates: [Update],
        isIncluded: ([Page], [Page]) -> Bool
    ) -> Int {
        updates
            .compactMap { update in
                let sorted = update.pages.sorted()
                return isIncluded(sorted, update.pages) ? sorted : nil
            }
            .reduce(0) { result, pages in
                result + pages[pages.count / 2].value
            }
    }
}

private struct Rule {
    let number: Int
    let orderRuleNumber: Int
}

private struct Page: Comparable {
    let ruleNumbers: Set<Int>
    let value: Int

    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.ruleNumbers.contains(rhs.value)
    }
}

private struct Update {
    let pages: [Page]
}

extension Update {
    init(rules: [Int: Set<Int>], values: [Int]) {
        self.init(
            pages: values.map { value in
                Page(
                    ruleNumbers: rules[value] ?? [],
                    value: value
                )
            }
        )
    }
}

extension Array where Element == ([Int: Set<Int>], [[Int]]) {
    fileprivate static func buildUpdates(_ element: Element) -> [Update] {
        let rules = element.0
        let updates = element.1
        return updates.map { values in
            Update(rules: rules, values: values)
        }
    }
}

private struct RuleParser: Parser {
    var body: some Parser<Substring, Rule> {
        Parse(Rule.init) {
            Int.parser()
            "|"
            Int.parser()
        }
    }
}

private struct RulesParser: Parser {
    var body: some Parser<Substring, [Int: Set<Int>]> {
        Many(into: [Int: Set<Int>]()) { result, rule in
            result[rule.number, default: Set<Int>()].insert(rule.orderRuleNumber)
        } element: {
            RuleParser()
        } separator: {
            "\n"
        } terminator: {
            "\n"
        }
    }
}

private struct UpdateParser: Parser {
    var body: some Parser<Substring, [Int]> {
        Many {
            Int.parser()
        } separator: {
            ","
        }
    }
}

private struct UpdatesParser: Parser {
    var body: some Parser<Substring, [[Int]]> {
        Many {
            UpdateParser()
        } separator: {
            "\n"
        } terminator: {
            End()
        }
    }
}

private struct SafetyManualParser: Parser {
    var body: some Parser<Substring, [Update]> {
        Parse(Array.buildUpdates) {
            RulesParser()
            "\n"
            UpdatesParser()
        }
    }
}
