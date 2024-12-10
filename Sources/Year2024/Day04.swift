import Core

public struct Day04: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        let grid = data
            .components(separatedBy: "\n")
            .map(Array.init)
        var count = 0
        let directions = [(0, -1), (-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1)]
        for i in grid.indices {
            for j in grid[i].indices {
                for direction in directions {
                    if findSequence("XMAS", startingAt: (i, j), direction: direction, grid: grid) {
                        count += 1
                    }
                }
            }
        }
        return count
    }

    public func part2() async throws -> Int {
        let grid = data
            .components(separatedBy: "\n")
            .map(Array.init)
        let directions = [(-1, -1), (-1, 1), (1, 1), (1, -1)]
        var count = [Position: Int]()
        for i in grid.indices {
            for j in grid[i].indices {
                for direction in directions {
                    if findSequence("MAS", startingAt: (i, j), direction: direction, grid: grid) {
                        let crossCenter = Position(x: i + direction.0, y: j + direction.1)
                        count[crossCenter, default: 0] += 1
                    }
                }
            }
        }
        return count.values.count { $0 == 2 }
    }

    private func findSequence(
        _ sequence: String,
        startingAt position: (Int, Int),
        direction: (Int, Int),
        grid: [[String.Element]],
        currentFound: String = ""
    ) -> Bool {
        guard
            position.0 >= 0,
            position.1 >= 0,
            position.0 < grid.count,
            position.1 < grid[position.0].count
        else {
            return false
        }
        let current = currentFound.appending("\(grid[position.0][position.1])")
        if current == sequence {
            return true
        } else if current == sequence.prefix(current.count) {
            return findSequence(
                sequence,
                startingAt: (position.0 + direction.0, position.1 + direction.1),
                direction: direction,
                grid: grid,
                currentFound: current
            )
        }
        return false
    }
}

struct Position {
    var x: Int
    var y: Int
}

extension Position: Hashable {}
