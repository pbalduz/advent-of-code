import Foundation
import RegexBuilder

public struct Day15: Runnable {

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
        let input = try readFile("day15-input", withExtension: "txt")

        let sensors = parseInput(input)

        return Result(
            part1: findBlockedPositions(
                for: sensors,
                atHeight: 2_000_000
            ),
            part2: findFirstAvailablePosition(for: sensors) ?? -1
        )
    }

    private func findBlockedPositions(
        for sensors: [Sensor],
        atHeight y: Int
    ) -> Int {
        let xPositions = sensors
            .compactMap { $0.position.range(at: y, forDistance: $0.distance) }
            .union()
        let sensorsCount = sensors
                .map(\.position)
                .filter { $0.y == y }
                .count
        let beaconsCount = sensors
                .map(\.beacon)
                .filter { $0.y == y }
                .removingDuplicates()
                .count

        return xPositions.count - sensorsCount - beaconsCount
    }

    private func findFirstAvailablePosition(for sensors: [Sensor]) -> Int? {
        let limitRange = 0 ... 4_000_000
        for y in limitRange {
            var availableX = IndexSet(integersIn: limitRange)
            for sensor in sensors {
                let blockedRange = sensor.position.range(
                    at: y,
                    forDistance: sensor.distance
                )
                if let sensorRange = blockedRange?.bounded(by: limitRange) {
                    availableX.remove(integersIn: sensorRange)
                }
            }

            if let x = availableX.first {
                return x * 4_000_000 + y
            }
        }
        return nil
    }
}

private func parseInput(_ input: String) -> [Sensor] {
    var sensors = [Sensor]()
    for match in input.matches(of: regex) {
        let sensorPosition = Position(x: match.1, y: match.2)
        let beaconPosition = Position(x: match.3, y: match.4)
        sensors.append(
            Sensor(
                position: sensorPosition,
                beacon: beaconPosition
            )
        )
    }
    return sensors
}

private struct Sensor {
    let position: Position
    let beacon: Position

    var distance: Int {
        Position.manhattanDistance(
            lhs: position,
            rhs: beacon
        )
    }
}

private struct Position: Hashable {
    let x: Int
    let y: Int

    static func manhattanDistance(lhs: Position, rhs: Position) -> Int {
        abs(lhs.x - rhs.x) + abs(lhs.y - rhs.y)
    }

    func range(at y: Int, forDistance distance: Int) -> ClosedRange<Int>? {
        guard (self.y - distance) ... (self.y + distance) ~= y else {
            return nil
        }
        let x1 = x - (distance - abs(y - self.y))
        let x2 = x + (distance - abs(y - self.y))
        return x1 ... x2
    }
}

private let number = TryCapture {
    Optionally("-")
    OneOrMore(.digit)
} transform: {
    Int($0)
}

private let coordinate = Regex {
    "x="
    number
    ", y="
    number
}

private let regex = Regex {
    "Sensor at "
    coordinate
    ": closest beacon is at "
    coordinate
}
