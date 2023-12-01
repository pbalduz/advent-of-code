import Foundation
import RegexBuilder

public struct Day11: Runnable {

    public struct Result: CustomStringConvertible {
        let part1: Int
        let part2: Int

        public var description: String {
            """
            Worry level 20 rounds: \(part1)
            Worry level 10_000 rounds: \(part2)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let content = try readFile("day11-input", withExtension: "txt")

        let monkeys = content
            .matches(of: regex)
            .map {
                Monkey(
                    items: $0[itemsReference],
                    operation: Operation(
                        operator: $0[operatorReference],
                        lhsComponent: $0[operationlhsReference],
                        rhsComponent: $0[operationrhsReference]
                    ),
                    testValue: $0[testValueReference],
                    destinationTrue: $0[destinationTrueReference],
                    destinationFalse: $0[destinationFalseReference]
                )
            }

        return Result(
            part1: computeMonkeyBusiness(
                monkeys: monkeys,
                roundsCount: 20,
                dividingWorryLevels: true
            ),
            part2: computeMonkeyBusiness(
                monkeys: monkeys,
                roundsCount: 10_000,
                dividingWorryLevels: false
            )
        )
    }

    private func computeMonkeyBusiness(
        monkeys: [Monkey],
        roundsCount: Int,
        dividingWorryLevels shouldDivideWorryLevels: Bool
    ) -> Int {
        var monkeysCopy = monkeys
        for _ in 1 ... roundsCount {
            for index in monkeysCopy.indices {
                for item in monkeysCopy[index].items {
                    var worryLevel = monkeysCopy[index].computeWorryLevel(forItem: item)
                    if shouldDivideWorryLevels {
                        worryLevel = worryLevel / 3
                    }
                    worryLevel = worryLevel % monkeysCopy.map(\.testValue).reduce(1, *)
                    let destination = worryLevel.isMultiple(of: monkeysCopy[index].testValue) ? monkeysCopy[index].destinationTrue : monkeysCopy[index].destinationFalse
                    monkeysCopy[destination].items.append(worryLevel)
                    monkeysCopy[index].inspectedItemsCount += 1
                }
                monkeysCopy[index].items.removeAll()
            }
        }

        return monkeysCopy
            .map(\.inspectedItemsCount)
            .sorted(by: >)[0 ... 1]
            .reduce(1, *)
    }
}

private typealias Operator = (Int, Int) -> Int

private struct Operation {
    enum Component {
        case old
        case value(Int)

        init(value: Substring) {
            if let int = Int(value) {
                self = .value(int)
            } else {
                self = .old
            }
        }
    }

    let `operator`: Operator
    let lhsComponent: Component
    let rhsComponent: Component
}

private extension Int {
    func value(forComponentType component: Operation.Component) -> Int {
        if case let .value(value) = component {
            return value
        }
        return self
    }
}

private struct Monkey {
    var items: [Int]
    let operation: Operation
    let testValue: Int
    let destinationTrue: Int
    let destinationFalse: Int

    var inspectedItemsCount: Int = 0

    func computeWorryLevel(forItem item: Int) -> Int {
        return Int(
            operation.`operator`(
                item.value(forComponentType: operation.lhsComponent),
                item.value(forComponentType: operation.rhsComponent)
            )
        )
    }
}

private let headerRegex = Regex {
    "Monkey"
    One(.whitespace)
    OneOrMore(.digit)
    ":"
}

private let itemsReference = Reference([Int].self)
private let startingItemsRegex = Regex {
    OneOrMore(.whitespace)
    "Starting items: "
    TryCapture(as: itemsReference) {
        OneOrMore(.anyNonNewline)
    } transform: { value in
        value
            .split { ", " }
            .compactMap { Int(String($0)) }
    }
}

private func parseOperator(for string: Substring) -> Operator? {
    switch string {
    case "+":
        return (+)

    case "*":
        return (*)

    default:
        return nil
    }
}

private let operationlhsReference = Reference(Operation.Component.self)
private let operationrhsReference = Reference(Operation.Component.self)
private let operatorReference = Reference(Operator.self)
private let operationComponent = ChoiceOf {
    "old"
    OneOrMore(.digit)
}
private let operationRegex = Regex {
    OneOrMore(.whitespace)
    "Operation: new = "
    Capture(as: operationlhsReference) {
        operationComponent
    } transform: { Operation.Component(value: $0) }
    One(.whitespace)
    TryCapture(as: operatorReference) {
        One(.any)
    } transform: { parseOperator(for: $0) }
    One(.whitespace)
    Capture(as: operationrhsReference) {
        operationComponent
    } transform: { Operation.Component(value: $0) }
}

private let testValueReference = Reference(Int.self)
private let destinationTrueReference = Reference(Int.self)
private let destinationFalseReference = Reference(Int.self)
private let testRegex = Regex {
    OneOrMore(.any, .reluctant)
    TryCapture(as: testValueReference) {
        OneOrMore(.digit)
    } transform: { Int($0) }
    OneOrMore(.any, .reluctant)
    TryCapture(as: destinationTrueReference) {
        OneOrMore(.digit)
    } transform: { Int($0) }
    OneOrMore(.any, .reluctant)
    TryCapture(as: destinationFalseReference) {
        OneOrMore(.digit)
    } transform: { Int($0) }
}

private let regex = Regex {
    headerRegex
    startingItemsRegex
    operationRegex
    testRegex
}
