import Foundation
import RegexBuilder

public struct Day10: Runnable {

    public struct Result: CustomStringConvertible {
        let signalStrengthsSum: Int

        public var description: String {
            """
            Signal strengths sum: \(signalStrengthsSum)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let content = try readFile("day10-input", withExtension: "txt")

        var cycles = [Int]()
        var currentValue = 1

        for command in parseCommands(content) {
            switch command {
            case .noop:
                cycles.append(currentValue)

            case let .addx(value):
                for cycle in 1 ... 2 {
                    cycles.append(currentValue)
                    currentValue += cycle == 2 ? value : 0
                }
            }
        }

        for row in cycles.chunked(into: 40) {
            for cycle in row.enumerated() {
                let pixel = abs(cycle.offset - cycle.element.value) <= 1 ? "⚪️" : "⚫️"
                print(pixel, terminator: " ")
            }
            print("\n")
        }

        let cyclesOfInterest = [20, 60, 100, 140, 180, 220]
        let signalStrengthsSum = cyclesOfInterest
            .map { cycles[$0 - 1].value * $0 }
            .reduce(0, +)

        return Result(signalStrengthsSum: signalStrengthsSum)
    }
}

private let parseCommands: (String) -> [Command] = { content in
    content.matches(of: regex).compactMap {
        Command(
            name: String($0.1),
            value: $0.2
        )
    }
}

private let regex = Regex {
    Capture {
        ChoiceOf {
            "addx"
            "noop"
        }
    }
    Optionally {
        OneOrMore(.whitespace)
        TryCapture {
            OneOrMore(.anyNonNewline)
        } transform: { Int($0) }
    }
}

private enum Command {
    case addx(Int)
    case noop

    init?(name: String, value: Int?) {
        switch name {
        case "addx":
            guard let value else { return nil }
            self = .addx(value)

        case "noop":
            self = .noop

        default:
            return nil
        }
    }
}
