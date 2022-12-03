import Foundation

public struct Day2: Runnable {
    public struct Result: CustomStringConvertible {
        let totalScore: Int
        let totalScoreWithStrategy: Int

        public var description: String {
            """
            Total core: \(totalScore)
            Total core with strategy: \(totalScoreWithStrategy)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let content = try readFile("day2-input", withExtension: "txt")

        let plays = content
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: " ") }
            .compactMap(Play.init)

        let totalScore = plays.map {
            $0.score(shouldFollowStrategy: false)
        }.reduce(0, +)

        let totalScoreWithStrategy = plays.map {
            $0.score(shouldFollowStrategy: true)
        }.reduce(0, +)

        return Result(
            totalScore: totalScore,
            totalScoreWithStrategy: totalScoreWithStrategy
        )
    }
}

enum Strategy: String {
    case win = "Z"
    case loose = "X"
    case draw = "Y"

    var defaultShape: Shape {
        switch self {
        case .win:
            return .scissors
        case .loose:
            return .rock
        case .draw:
            return .paper
        }
    }

    func shape(against shape: Shape) -> Shape {
        switch (self) {
        case .win:
            return shape.winningShape
        case .loose:
            return shape.loosingShape
        case .draw:
            return shape
        }
    }
}

enum Shape: String {
    case rock = "A"
    case paper = "B"
    case scissors = "C"

    var score: Int {
        switch self {
        case .rock: return 1
        case .paper: return 2
        case .scissors: return 3
        }
    }

    var winningShape: Shape {
        switch self {
        case .rock: return .paper
        case .paper: return .scissors
        case .scissors: return .rock
        }
    }

    var loosingShape: Shape {
        switch self {
        case .rock: return .scissors
        case .paper: return .rock
        case .scissors: return .paper
        }
    }
}

struct Play {
    let shape: Shape
    let strategy: Strategy

    init?(_ values: [String]) {
        guard
            values.count == 2,
            let shape = values.first.flatMap(Shape.init),
            let strategy = values.last.flatMap(Strategy.init)
        else {
            return nil
        }
        self.shape = shape
        self.strategy = strategy
    }

    func score(shouldFollowStrategy: Bool) -> Int {
        let targetShape = shouldFollowStrategy ? strategy.shape(against: shape) : strategy.defaultShape
        let playScore = playScore(for: targetShape, against: shape)
        let shapeScore = targetShape.score
        return playScore + shapeScore
    }

    private func playScore(for targetShape: Shape, against comparisonShape: Shape) -> Int {
        switch (targetShape, comparisonShape) {
        case (.rock, .rock),
            (.paper, .paper),
            (.scissors, .scissors):
            return 3

        case (.rock, .scissors),
            (.paper, .rock),
            (.scissors, .paper):
            return 6

        case (.scissors, .rock),
            (.rock, .paper),
            (.paper, .scissors):
            return 0
        }
    }
}
