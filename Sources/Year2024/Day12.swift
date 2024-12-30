import Collections
import Core

public struct Day12: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        Array2D(data)
            .mapRegions()
            .map(\.price)
            .reduce(0, +)
    }

    public func part2() async throws -> Int {
        Array2D(data)
            .mapRegions()
            .map(\.reducedPrice)
            .reduce(0, +)
    }
}

extension Array2D where Element == Character {
    fileprivate func mapRegions() -> [Region] {
        var regions: [Region] = []

        var visited: Set<Point2D> = []
        for index in self.indices {
            let point = self.point(for: index)
            guard !visited.contains(point) else { continue }

            var deque = Deque([point])
            var positions: Set<Point2D> = []

            while let next = deque.popFirst() {
                guard
                    !positions.contains(next),
                    self.hasPoint(next),
                    self[next] == self[point]
                else {
                    continue
                }

                positions.insert(next)
                deque.append(contentsOf: next.neighbours(display: .cross))
            }

            regions.append(
                Region(value: self[index], positions: positions)
            )
            visited.formUnion(positions)
        }

        return regions
    }
}

private struct Region {
    let value: Character
    let positions: Set<Point2D>

    var area: Int { positions.count }

    var perimeter: Int {
        positions.reduce(0) { result, position in
            let value = position
                .neighbours(display: .cross)
                .filter { !positions.contains($0) }
                .count
            return result + value
        }
    }

    var sides: Int {
        positions.reduce(0) { result, position in
            let neighbours = position
                .neighbours(display: .diagonal)

            let corners = neighbours.reduce(0) { corners, neighbour in
                    switch neighbour {
                    case Point2D(x: position.x - 1, y: position.y - 1):
                        if !positions.contains(position.moved(.up)) && !positions.contains(position.moved(.left)) {
                            return corners + 1
                        } else if positions.contains(position.moved(.up)) && positions.contains(position.moved(.left)) {
                            return corners + (positions.contains(neighbour) ? 0 : 1)
                        } else {
                            return corners
                        }

                    case Point2D(x: position.x + 1, y: position.y - 1):
                        if !positions.contains(position.moved(.up)) && !positions.contains(position.moved(.right)) {
                            return corners + 1
                        } else if positions.contains(position.moved(.up)) && positions.contains(position.moved(.right)) {
                            return corners + (positions.contains(neighbour) ? 0 : 1)
                        } else {
                            return corners
                        }

                    case Point2D(x: position.x - 1, y: position.y + 1):
                        if !positions.contains(position.moved(.left)) && !positions.contains(position.moved(.down)) {
                            return corners + 1
                        } else if positions.contains(position.moved(.left)) && positions.contains(position.moved(.down)) {
                            return corners + (positions.contains(neighbour) ? 0 : 1)
                        } else {
                            return corners
                        }

                    case Point2D(x: position.x + 1, y: position.y + 1):
                        if !positions.contains(position.moved(.right)) && !positions.contains(position.moved(.down)) {
                            return corners + 1
                        } else if positions.contains(position.moved(.right)) && positions.contains(position.moved(.down)) {
                            return corners + (positions.contains(neighbour) ? 0 : 1)
                        } else {
                            return corners
                        }

                    default:
                        return corners
                    }
            }
            return result + corners
        }
    }

    var price: Int { area * perimeter }

    var reducedPrice: Int { area * sides }
}
