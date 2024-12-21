import Algorithms
import Core
import Parsing

public struct Day08: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        let map = Array2D(data, transform: Antenna.init)
        let chunks = map
            .filter({ $0.value != "." })
            .grouped(by: \.value)

        let positions = chunks.reduce(into: Set<Point2D>()) { result, chunk in
            let combinations = chunk.value.permutations()
            let positions = combinations.compactMap { $0[0].position.singleAntinode(for: $0[1].position, in: map) }
            positions.forEach { result.insert($0) }
        }
        return positions.count
    }

    public func part2() async throws -> Int {
        let map = Array2D(data, transform: Antenna.init)
        let chunks = map
            .filter({ $0.value != "." })
            .grouped(by: \.value)

        let positions = chunks.reduce(into: Set<Point2D>()) { result, chunk in
            let combinations = chunk.value.permutations()
            let positions = combinations.flatMap { $0[0].position.antinodes(for: $0[1].position, in: map) }
            positions.forEach { result.insert($0) }
        }
        return positions.count
    }
}

private struct Antenna {
    let position: Point2D
    let value: Character
}

extension Point2D {
    fileprivate func singleAntinode(for point: Point2D, in map: Array2D<Antenna>) -> Point2D? {
        let antinode = point + (point - self)
        guard map.hasPoint(antinode) else { return nil }
        return antinode
    }

    fileprivate func antinodes(for point: Point2D, in map: Array2D<Antenna>) -> [Point2D] {
        var antinodes: [Point2D] = [point]
        var current = self
        var next = point
        while let antinode = current.singleAntinode(for: next, in: map) {
            antinodes.append(antinode)
            current = next
            next = antinode
        }
        return antinodes
    }
}
