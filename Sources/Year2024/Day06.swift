import Core
import Foundation

public struct Day06: AdventDay {
    let data: String

    private let map: Array2D<Character>

    public init(data: String) {
        self.data = data
        self.map = Array2D(data)
    }

    public func part1() async throws -> Int {
        var iterator = Iterator(
            map: map,
            start: map.firstPoint(where: { $0 == Character("^") })!
        )
        var visitedPoints = Set<Point2D>()
        while let next = iterator.next() {
            visitedPoints.insert(next.point)
        }
        return visitedPoints.count
    }

    public func part2() async throws -> Int {
        var iterator = Iterator(
            map: map,
            start: map.firstPoint(where: { $0 == Character("^") })!
        )
        var loopPoints = Set<Point2D>()
        while let next = iterator.next() {
            guard map[next.point] != Character("^") else { continue }
            var steps = Set<Step>()
            var updatedMap = map
            updatedMap[next.point] = Character("#")
            var loopIterator = Iterator(
                map: updatedMap,
                start: map.firstPoint(where: { $0 == Character("^") })!
            )
            while let loopNext = loopIterator.next() {
                if steps.contains(loopNext) {
                    loopPoints.insert(next.point)
                    break
                }
                steps.insert(loopNext)
            }
        }
        return loopPoints.count
    }
}

private struct Step: Hashable {
    let direction: Direction
    let point: Point2D
}

private struct Iterator: IteratorProtocol {
    private let map: Array2D<Character>
    private var current: Point2D
    private var direction: Direction = .up
    private var didSendStart: Bool = false

    init(map: Array2D<Character>, start: Point2D) {
        self.map = map
        self.current = start
    }

    mutating func next() -> Step? {
        guard didSendStart else {
            didSendStart.toggle()
            return Step(direction: direction, point: current)
        }
        let nextPoint = current.moved(direction)
        guard let next = map[safe: nextPoint] else {
            return nil
        }
        if next == Character("#") {
            direction = direction.turn(.clockwise)
        } else {
            current = nextPoint
        }
        return Step(direction: direction, point: current)
    }
}
