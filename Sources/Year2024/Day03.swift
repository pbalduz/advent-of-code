import Core
import Foundation
import Parsing
import RegexBuilder

public struct Day03: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        let instructions = data
            .matches(of: mulRegex)
            .map { Pair(first: $0.output.1, second: $0.output.2) }
        return instructions.reduce(0) {
            $0 + $1.first * $1.second
        }
    }

    public func part2() async throws -> Int {
        var isEnabled = true
        return data
            .matches(of: regex)
            .reduce(0) { result, match in
                let instruction = match[instructionRef]
                switch instruction {
                case "do()":
                    isEnabled = true

                case "don't()":
                    isEnabled = false

                default:
                    if isEnabled {
                        return result + match.output.2! * match.output.3!
                    }
                }
                return result
            }
    }
}

let mulRegex = Regex {
    "mul("
    TryCapture {
        OneOrMore(.digit)
    } transform: { Int($0) }
    ","
    TryCapture {
        OneOrMore(.digit)
    } transform: { Int($0) }
    ")"
}

let instructionRef = Reference<Substring>()
private let regex = Regex {
    Capture(as: instructionRef) {
        ChoiceOf {
            "do()"
            "don't()"
            mulRegex
        }
    }
}
