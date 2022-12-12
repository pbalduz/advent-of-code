import Foundation

public struct Day8: Runnable {

    public struct Result: CustomStringConvertible {
        let visibleTrees: Int
        let scenicScore: Int

        public var description: String {
            """
            Visible trees: \(visibleTrees)
            Highest scenic score: \(scenicScore)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let content = try readFile("day8-input", withExtension: "txt")

        let forest: Forest = content
            .split { $0 == "\n" }
            .map { $0.compactMap(\.wholeNumberValue) }

        let outterTreesCount = forest.count * 2 + (forest.first?.count ?? 0) * 2 - 4
        var visibleTrees = outterTreesCount
        var scenicScores = [Int]()
        for (y, _) in forest.enumerated()
            .dropFirst()
            .dropLast() {
            for (x, _) in forest[y].enumerated()
                .dropFirst()
                .dropLast() {
                let position = Position(x: x, y: y)
                if forest.isVisible(at: position) {
                    visibleTrees += 1
                }
                scenicScores.append(forest.scenicScore(at: position))
            }
        }

        return Result(
            visibleTrees: visibleTrees,
            scenicScore: scenicScores.max() ?? 0
        )
    }
}

typealias Tree = Int
typealias Forest = [[Tree]]

extension Forest {
    subscript(position: Position) -> Int? {
        guard
            position.y >= 0,
            position.y < count,
            position.x >= 0,
            position.x < self[position.y].count
        else {
            return nil
        }
        return self[position.y][position.x]
    }

    func isVisible(at position: Position) -> Bool {
        isVisibleFromAbove(at: position) ||
        isVisibleFromBelow(at: position) ||
        isVisibleFromLeft(at: position) ||
        isVisibleFromRight(at: position)
    }

    func scenicScore(at position: Position) -> Int {
        let upperViewingDistance = viewingDistance(
            for: position,
            regarding: (0 ..< position.y)
                .compactMap { Position(x: position.x, y: $0) }
                .reversed()
        )
        let lowerViewingDistance = viewingDistance(
            for: position,
            regarding: (position.y + 1 ..< count)
                .compactMap { Position(x: position.x, y: $0) }
        )
        let leftViewingDistance = viewingDistance(
            for: position,
            regarding: (0 ..< position.x)
                .compactMap { Position(x: $0, y: position.y) }
                .reversed()
        )
        let rightViewingDistance = viewingDistance(
            for: position,
            regarding: (position.x + 1 ..< self[position.y].count)
                .compactMap { Position(x: $0, y: position.y) }
        )
        return upperViewingDistance * lowerViewingDistance * leftViewingDistance * rightViewingDistance
    }

    func isVisibleFromAbove(at position: Position) -> Bool {
        (0 ..< position.y)
            .allSatisfy { self[Position(x: position.x, y: $0)] ?? 0 < self[position] ?? 0 }
    }

    func isVisibleFromBelow(at position: Position) -> Bool {
        (position.y + 1 ..< count)
            .allSatisfy { self[Position(x: position.x, y: $0)] ?? 0 < self[position] ?? 0 }
    }

    func isVisibleFromLeft(at position: Position) -> Bool {
        (0 ..< position.x)
            .allSatisfy { self[Position(x: $0, y: position.y)] ?? 0 < self[position] ?? 0 }
    }

    func isVisibleFromRight(at position: Position) -> Bool {
        (position.x + 1 ..< self[position.y].count)
            .allSatisfy { self[Position(x: $0, y: position.y)] ?? 0 < self[position] ?? 0 }
    }
    
    private func viewingDistance(for position: Position, regarding positions: [Position]) -> Int {
        var distance = 0
        for position_ in positions {
            distance += 1
            if self[position_] ?? 0 >= self[position] ?? 0 { return distance }
        }
        return distance
    }
}

struct Position {
    let x: Int
    let y: Int
}
