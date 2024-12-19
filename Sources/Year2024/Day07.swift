import Core
import Parsing

public struct Day07: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        let operations = [
            (+) as (Int, Int) -> Int,
            (*)
        ]
        let equations = try EquationsParser().parse(data)
        return equations
            .filter { $0.isValid(for: operations) }
            .map(\.result)
            .reduce(0, +)
    }

    public func part2() async throws -> Int {
        let operations = [
            (+) as (Int, Int) -> Int,
            (*),
            (||)
        ]
        let equations = try EquationsParser().parse(data)
        return await withTaskGroup(of: Int.self) { group in
            for equation in equations {
                let task = Task {
                    await withCheckedContinuation { continuation in
                        let result = equation.isValid(for: operations) ? equation.result : 0
                        continuation.resume(returning: result)
                    }
                }
                group.addTask { await task.value }
            }
            return await group.reduce(0, +)
        }
    }
}

private struct Equation {
    let result: Int
    let constants: [Int]

    func isValid(for operations: [(Int, Int) -> Int]) -> Bool {
        let combinations = operations.combinations(count: constants.count - 1)
        let possibleResults = combinations.map { combination in
            var combination = combination
            return constants
                .dropFirst()
                .reduce(constants.first!) {
                    combination.removeFirst()($0, $1)
                }
        }
        return possibleResults.contains(result)
    }
}

private let equation = Parse(
    input: Substring.self,
    Equation.init
) {
    Int.parser()
    ": "
    Many {
        Int.parser()
    } separator: {
        " "
    }
}

private struct EquationsParser: Parser {
    var body: some Parser<Substring, [Equation]> {
        Many {
            equation
        } separator: {
            "\n"
        }
    }
}
