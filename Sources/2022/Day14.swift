import Foundation

public struct Day14: Runnable {

    public struct Result: CustomStringConvertible {
        let part1: Int
        let part2: Int

        public var description: String {
            """
            Part 1: \(part1)
            Part 2: \(part2)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let input = try readFile("day14-input", withExtension: "txt")

        let grid = input
            .components(separatedBy: "\n")
            .map(parsePositions(forPath:))
            .reduce([Position: Item]()) { result, dict in
                result.merging(dict) { (current, _) in current }
            }

        let startingPosition = Position(x: 500, y: 0)

        var grid1 = grid
        var position1: Position? = startingPosition
        while position1 != nil {
            position1 = dropSand(
                from: startingPosition,
                inGrid: &grid1,
                bottomLimit: grid.keys.map(\.y).max()!,
                endlessFloor: true
            )
        }

        var grid2 = grid
        var position2: Position?
        while position2 != startingPosition {
            position2 = dropSand(
                from: startingPosition,
                inGrid: &grid2,
                bottomLimit: grid.keys.map(\.y).max()! + 2,
                endlessFloor: false
            )
        }

        return Result(
            part1: grid1.values.filter { $0 == .sand }.count,
            part2: grid2.values.filter { $0 == .sand }.count
        )
    }
}

private struct Position: CustomStringConvertible, Hashable {
    var x: Int
    var y: Int

    var description: String { "(x: \(x), y: \(y))" }

    var bottomLeft: Position {
        .init(x: x - 1, y: y + 1)
    }
    var bottomRight: Position {
        .init(x: x + 1, y: y + 1)
    }
    var down: Position {
        .init(x: x, y: y + 1)
    }

    func positionsUntil(_ position: Position) -> [Position] {
        var positions = [Position]()
        if x == position.x {
            let edges = [y, position.y].sorted()
            positions.append(
                contentsOf: (edges.first! ... edges.last!)
                    .map { Position(x: x, y: $0) }
            )
        }
        if y == position.y {
            let edges = [x, position.x].sorted()
            positions.append(
                contentsOf: (edges.first! ... edges.last!)
                    .map { Position(x: $0, y: y) }
            )
        }
        return positions
    }
}

private extension Position {
    init(_ string: String) {
        let values = string.split { $0 == "," }
        x = Int(values.first!)!
        y = Int(values.last!)!
    }
}

private func dropSand(
    from start: Position,
    inGrid grid: inout [Position: Item],
    bottomLimit: Int,
    endlessFloor: Bool
) -> Position? {
    var movingPosition = start
    let floor = endlessFloor ? nil : bottomLimit
    while movingPosition.y <= bottomLimit {
        if grid[movingPosition.down, floor: floor] == nil {
            movingPosition = movingPosition.down
        } else if grid[movingPosition.bottomLeft, floor: floor] == nil {
            movingPosition = movingPosition.bottomLeft
        } else if grid[movingPosition.bottomRight, floor: floor] == nil {
            movingPosition = movingPosition.bottomRight
        } else {
            grid[movingPosition] = .sand
            return movingPosition
        }
    }
    return nil
}

private extension Dictionary where Key == Position, Value == Item {
    subscript(position: Position, floor floor: Int?) -> Item? {
        if let floor, position.y == floor {
            return .rock
        }
        return self[position]
    }
}

private enum Item: CustomStringConvertible {
    case rock
    case sand

    var description: String {
        switch self {
        case .rock: return "#"
        case .sand: return "o"
        }
    }
}

private func parsePositions(forPath path: String) -> [Position: Item] {
    let referencePositions = path
        .components(separatedBy: " -> ")
        .map(Position.init)

    var positions = [Position: Item]()

    for index in 0 ..< referencePositions.count - 1 {
        let current = referencePositions[index]
        let next = referencePositions[index + 1]
        for position in current.positionsUntil(next) {
            positions[position] = .rock
        }
    }
    return positions
}

private func displayGrid(_ grid: [Position: Item]) {
    let minx = grid.keys.map(\.x).min()!
    let miny = grid.keys.map(\.y).min()!
    let maxx = grid.keys.map(\.x).max()!
    let maxy = grid.keys.map(\.y).max()!
    for y in miny ... maxy {
        var items: [String] = []
        for x in minx ... maxx {
            items.append(grid[Position(x: x, y: y)]?.description ?? " ")
        }
        print(items.joined())
    }
}
