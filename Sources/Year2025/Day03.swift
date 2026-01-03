import Core
import Foundation

public struct Day03: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        data
            .lines
            .compactMap { Int($0.joltage(length: 2)) }
            .reduce(0, +)
    }

    public func part2() async throws -> Int {
        data
            .lines
            .compactMap { Int($0.joltage(length: 12)) }
            .reduce(0, +)
    }
}

extension String {
    fileprivate func joltage(length: Int) -> Int {
        Int(largestDigits(length: length)) ?? .zero
    }
}
