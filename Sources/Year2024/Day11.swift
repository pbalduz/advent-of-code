import Core
import _math
import Parsing

public struct Day11: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        let stones = try StonesParser().parse(data).keys.map { $0 }
        return (0..<25)
            .reduce(stones) { stones, _ in
                stones.reduce(into: [Int]()) { temp, stone in
                    temp.append(contentsOf: divide(stone))
                }
            }.count
    }

    public func part2() async throws -> Int {
        let stones = try StonesParser().parse(data)
        return (0..<75)
            .reduce(into: stones) { stones, _ in
                blink(stones: &stones)
            }
            .values
            .reduce(0, +)
    }

    private func blink(stones: inout [Int: Int]) {
        let copy = stones
        for (key, value) in copy {
            let division = divide(key)
            for new in division {
                stones[new, default: 0] += value
            }
            stones[key, default: 0] -= value
            if let value = stones[key], value <= 0 {
                stones.removeValue(forKey: key)
            }
        }
    }

    private func divide(_ stone: Int) -> [Int] {
        switch stone {
        case 0:
            return [1]

        case let num where num.digitsCount.isEven:
            let exp = Double(num.digitsCount / 2)
            return [
                num / Int(pow(10, exp)),
                num % Int(pow(10, exp))
            ]

        default:
            return [stone * 2024]
        }
    }
}

private struct StonesParser: Parser {
    var body: some Parser<Substring, [Int: Int]> {
        Many(into: [Int: Int]()) { stones, int in
            stones[int, default: 0] += 1
        } element: {
            Int.parser()
        } separator: {
            " "
        } terminator: {
            End()
        }

    }
}
