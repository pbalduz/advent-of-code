import Core
import RegexBuilder

public struct Day02: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    let redTotal = 12
    let greenTotal = 13
    let blueTotal = 14
    
    public func part1() -> Any {
        data.matches(of: gameRegex)
            .reduce(into: 0) { result, value in
                let sets = value.output.2
                    .matches(of: cubesRegex)
                    .map {
                        CubeHand(
                            color: $0.output.2,
                            count: $0.output.1
                        )
                    }
                                
                if !sets.contains(
                    where: {
                        ($0.color == .red && $0.count > redTotal) ||
                        ($0.color == .green && $0.count > greenTotal) ||
                        ($0.color == .blue && $0.count > blueTotal)
                    }
                ) {
                    result += value.output.1
                }
            }
    }
    
    public func part2() -> Any {
        data.matches(of: gameRegex)
            .map {
                $0.output.2
                    .matches(of: cubesRegex)
                    .map {
                        CubeHand(
                            color: $0.output.2,
                            count: $0.output.1
                        )
                    }
                    .reduce(into: [Color: Int]()) { result, hand in
                        if !result.contains(
                            where: { $0.key == hand.color && $0.value > hand.count }
                        ) {
                            result[hand.color] = hand.count
                        }
                    }
                    .map(\.value)
                    .reduce(1, *)
            }
            .reduce(0, +)
    }
}

private enum Color: String {
    case red
    case green
    case blue
}

private struct CubeHand {
    let color: Color
    let count: Int
}

private let gameRegex = Regex {
    "Game "
    TryCapture {
        OneOrMore(.digit)
    } transform: { Int($0) }
    ": "
    Capture {
        OneOrMore(.anyNonNewline)
    }
}

private let cubesRegex = Regex {
    TryCapture {
        OneOrMore(.digit)
    } transform: { Int($0) }
    " "
    TryCapture {
        ChoiceOf {
            "red"
            "green"
            "blue"
        }
    } transform: { Color(rawValue: String($0)) }
}
