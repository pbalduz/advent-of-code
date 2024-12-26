import Collections
import Core

public struct Day10: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        let map = Array2D(data, transform: { $0.wholeNumberValue! })
        let roots: [Point2D] = map
            .indexed()
            .compactMap { index, value in
                guard value == 0 else {
                    return nil
                }
                return map.point(for: index)
            }

        return roots.reduce(0) {
            $0 + Set(map.findTrails(from: $1)).count
        }
    }

    public func part2() async throws -> Int {
        let map = Array2D(data, transform: { $0.wholeNumberValue! })
        let roots: [Point2D] = map
            .indexed()
            .compactMap { index, value in
                guard value == 0 else {
                    return nil
                }
                return map.point(for: index)
            }

        return roots.reduce(0) {
            $0 + map.findTrails(from: $1).count
        }
    }
}

extension Array2D where Element == Int {
    /// Returns an array with the final position for each possible trail.
    fileprivate func findTrails(from point: Point2D) -> [Point2D] {
        if self[point] == 9 {
            return [point]
        }

        let nextPositions = [Direction.up, .down, .left, .right]
            .map { point.moved($0) }
            .filter { self[safe: $0] == self[point] + 1 }
        return nextPositions.reduce(into: []) {
            $0.append(contentsOf: findTrails(from: $1))
        }
    }
}
