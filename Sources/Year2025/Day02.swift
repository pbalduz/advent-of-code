import Core
import Foundation

public struct Day02: AdventDay {
    let data: String
    let ranges: [ClosedRange<Int>]

    public init(data: String) {
        self.data = data
        self.ranges = data.parseRanges()
    }

    public func part1() async throws -> Int {
        ranges
            .flatMap { range in
                range.reduce(into: [Int]()) { result, value in
                    let string = String(value)
                    if string.isInvalid1() {
                        result.append(value)
                    }
                }
            }
            .reduce(0, +)
    }

    public func part2() async throws -> Int {
        ranges
            .flatMap { range in
                let invalid = range.reduce(into: [Int]()) { result, value in
                    let string = String(value)
                    if string.isInvalid2() {
                        result.append(value)
                    }
                }
                return invalid
            }
            .reduce(0, +)
    }
}

extension String {
    fileprivate func parseRanges() -> [ClosedRange<Int>] {
        components(separatedBy: ",").map {
            let limits = $0.components(separatedBy: "-")
            let lowerLimit = Int(limits[0]) ?? 0
            let upperLimit = Int(limits[1]) ?? 0
            return lowerLimit...upperLimit
        }
    }

    fileprivate func isInvalid1() -> Bool {
        guard
            first != "0",
            count.isEven
        else { return false  }
        return split(every: count / 2).areAllElementsEqual
    }

    fileprivate func isInvalid2() -> Bool {
        guard
            first != "0",
            count > 1
        else { return false  }

        for length in (1...count / 2) {
            if split(every: length).areAllElementsEqual {
                return true
            }
        }
        return false
    }
}
