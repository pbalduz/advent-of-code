import Foundation
import RegexBuilder

public struct Day9: Runnable {

    public struct Result: CustomStringConvertible {
        let tailPositionsLength2: Int
        let tailPositionsLength10: Int

        public var description: String {
            """
            Positions visited by tail with length 2: \(tailPositionsLength2)
            Positions visited by tail with length 10: \(tailPositionsLength10)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let content = try readFile("day9-input", withExtension: "txt")

        let moves = content.matches(of: regex).map {
            Move(
                direction: $0[directionReference],
                steps: $0[stepsReference]
            )
        }

        func tailPositions(along moves: [Move], ropeLength length: Int) -> Set<Position> {
            var rope = Array(repeating: Position(x: 0, y: 0), count: length)
            var tailPositions = Set([rope.last!])
            for move in moves {
                for _ in 0 ..< move.steps {
                    rope[0] = rope[0].position(for: move.direction)
                    for i in 1 ..< rope.count {
                        rope[i] = rope[i].position(following: rope[i - 1])
                    }
                    tailPositions.insert(rope.last!)
                }
            }
            return tailPositions
        }

        return Result(
            tailPositionsLength2: tailPositions(along: moves, ropeLength: 2).count,
            tailPositionsLength10: tailPositions(along: moves, ropeLength: 10).count
        )
    }
}

private struct Position: Hashable {
    var x: Int
    var y: Int

    func position(following position: Position) -> Position {
        guard !self.isAdjacent(to: position) else { return self }

        let newX = x + (position.x > x ? 1 : -1)
        let newY = y + (position.y > y ? 1 : -1)

        if position.x == self.x {
            return Position(x: x, y: newY)
        }

        if position.y == self.y {
            return Position(x: newX, y: y)
        }

        return Position(x: newX, y: newY)
    }

    func position(for direction: Direction) -> Position {
        switch direction {
        case .up:
            return Position(x: x, y: y + 1)

        case .down:
            return Position(x: x, y: y - 1)

        case .left:
            return Position(x: x - 1, y: y)

        case .right:
            return Position(x: x + 1, y: y)
        }
    }

    func isAdjacent(to position: Position) -> Bool {
        if self == position {
            return true
        }
        return abs(x - position.x) <= 1 && abs(y - position.y) <= 1
    }
}

private typealias Move = (direction: Direction, steps: Int)

private enum Direction: String {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"
}

private let directionReference = Reference(Direction.self)
private let stepsReference = Reference(Int.self)

private let regex = Regex {
    TryCapture(as: directionReference) {
        One(.word)
    } transform: { Direction(rawValue: String($0)) }
    OneOrMore(.whitespace)
    TryCapture(as: stepsReference) {
        OneOrMore(.digit)
    } transform: { Int($0) }
}
