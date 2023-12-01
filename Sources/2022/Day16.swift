import Foundation
import RegexBuilder

public struct Day16: Runnable {

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
        let input = try readFile("day16-input", withExtension: "txt")

        let valves = parseValves(input)
        let distancesGraph = buildDistancesGraph(valves: valves)

        let result1 = computeFlowRate(
            origin: "AA",
            distancesGraph: distancesGraph,
            visited: [],
            timeAvailable: 30,
            valves: valves
        )

        let result2 = computeFlowForTwoActors(
            origin: "AA",
            distancesGraph: distancesGraph,
            totalValves: valves
        )

        return Result(
            part1: result1,
            part2: result2
        )
    }
}

private struct Valve: Hashable, Identifiable {
    let id: String
    let flowRate: Int
    let neighbours: [Valve.ID]
}

private func computeFlowRate(
    origin: Valve.ID,
    distancesGraph: [Valve.ID: [Valve.ID: Int]],
    visited: Set<Valve.ID>,
    timeAvailable: Int,
    totalFlowRate: Int = 0,
    valves: [Valve.ID: Valve]
) -> Int {
    let possibleDestinations = distancesGraph[origin]!
        .filter { id, _ in !visited.contains(id) }
        .filter { _, distance in timeAvailable - distance - 1 > 0 }

    var flowRate = totalFlowRate
    for (id, distance) in possibleDestinations {
        guard let valve = valves[id] else { continue }
        var visited = visited
        visited.insert(id)
        flowRate = max(
            flowRate,
            computeFlowRate(
                origin: id,
                distancesGraph: distancesGraph,
                visited: visited,
                timeAvailable: timeAvailable - distance - 1,
                totalFlowRate: totalFlowRate + (timeAvailable - distance - 1) * valve.flowRate,
                valves: valves
            )
        )
    }
    return flowRate
}

private func computeFlowForTwoActors(
    origin: Valve.ID,
    distancesGraph: [Valve.ID: [Valve.ID: Int]],
    totalValves: [Valve.ID: Valve]
) -> Int {
    let possibleDestinations = distancesGraph.keys.filter { $0 != origin }
    var totalFlowRate = 0
    let valvesCombinations = possibleDestinations
        .combinations(count: possibleDestinations.count / 2)
        .map { $0.removingDuplicates() }
        .filter { $0.count == possibleDestinations.count / 2 }
    for valvesOption in valvesCombinations {
        let flowRate1 = computeFlowRate(
            origin: origin,
            distancesGraph: distancesGraph,
            visited: Set(valvesOption),
            timeAvailable: 26,
            valves: totalValves
        )
        let flowRate2 = computeFlowRate(
            origin: origin,
            distancesGraph: distancesGraph,
            visited: Set(possibleDestinations).subtracting(Set(valvesOption)),
            timeAvailable: 26,
            valves: totalValves
        )
        totalFlowRate = max(
            totalFlowRate,
            flowRate1 + flowRate2
        )
    }
    return totalFlowRate
}

private func buildDistancesGraph(valves: [Valve.ID: Valve]) -> [Valve.ID: [Valve.ID: Int]] {
    let nonZeroValves = valves.filter { $0.value.id == "AA" || $0.value.flowRate > 0 }
    var distancesGraph = [Valve.ID: [Valve.ID: Int]]()
    for (_, valve) in nonZeroValves {
        var queue = [valve]
        var distances = [valve.id: 0]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            for next in current.neighbours {
                if distances[next] == nil {
                    if let valve = valves[next] {
                        queue.append(valve)
                        distances[next] = distances[current.id]! + 1
                    }
                }
            }
        }
        distancesGraph[valve.id] = distances
            .filter { $0.value > 0 }
            .filter { id, _ in valves[id]?.flowRate ?? 0 > 0 }
    }
    return distancesGraph
}

// MARK: - Parsing

private func parseValves(_ input: String) -> [Valve.ID: Valve] {
    input.matches(of: valveRegex).reduce(into: [Valve.ID: Valve]()) { result, match in
        let valve = Valve(
            id: match.1,
            flowRate: match.2,
            neighbours: match.3
        )
        result[valve.id] = valve
    }
}

private let valveRegex = Regex {
    "Valve "
    Capture {
        OneOrMore(.word)
    } transform: { String($0) }
    " has flow rate="
    TryCapture {
        OneOrMore(.digit)
    } transform: { Int($0) }
    ChoiceOf {
        "; tunnels lead to valves "
        "; tunnel leads to valve "
    }
    Capture {
        OneOrMore(.anyNonNewline)
    } transform: { $0.components(separatedBy: ", ") }
}


