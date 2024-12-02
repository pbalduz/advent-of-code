import Core

public struct Day01: AdventDay {
    public let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() -> Int {
        data.components(separatedBy: "\n")
            .map {
                let digits = $0.compactMap(\.wholeNumberValue)
                guard
                    let first = digits.first,
                    let last = digits.last
                else {
                    return 0
                }
                return first * 10 + last
            }
            .reduce(0, +)
    }

    public func part2() -> Int {
        data.components(separatedBy: "\n")
            .map { line in
                var numbers = [Int]()
                for index in line.indices {
                    if let number = line[index].wholeNumberValue {
                        numbers.append(number)
                        continue
                    }
                    for number in Numbers.allCases {
                        guard line.range(of: number.rawValue, range: index..<line.endIndex)?.lowerBound == index else {
                            continue
                        }
                        numbers.append(number.value)
                        break
                    }
                }

                let first = numbers.first ?? 0
                let last = numbers.last ?? 0
                return first * 10 + last
            }
            .reduce(0, +)
    }
}

private enum Numbers: String, CaseIterable {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine

    var value: Int {
        switch self {
        case .one: 1
        case .two: 2
        case .three: 3
        case .four: 4
        case .five: 5
        case .six: 6
        case .seven: 7
        case .eight: 8
        case .nine: 9
        }
    }
}
