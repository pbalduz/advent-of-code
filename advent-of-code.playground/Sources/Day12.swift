import Foundation

public struct Day12: Runnable {

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
        let input = try readFile("day12-input", withExtension: "txt")

        let inputGrid = input
            .components(separatedBy: "\n")
            .map(Array.init)

        let nodes = inputGrid
            .indices
            .reduce(into: [Node]()) { nodes, y in
                nodes.append(contentsOf: inputGrid[y].indices.map { x in
                    Node(
                        label: String(inputGrid[y][x]),
                        position: Position(x: x, y: y)
                    )
                })
            }

        let firstGraph = buildGraph(
            nodes: nodes,
            followingLogic: .upwards
        )
        performAlgorithm(start: firstGraph.findNode(for: "S")!)

        let secondGraph = buildGraph(
            nodes: nodes,
            followingLogic: .downwards
        )
        performAlgorithm(start: secondGraph.findNode(for: "E")!)

        return Result(
            part1: firstGraph.findNode(for: "E")?.distance ?? 0,
            part2: secondGraph
                .filter { $0.label == "a" || $0.label == "S" }
                .compactMap(\.distance)
                .min() ?? 0
        )
    }

    private func buildGraph(nodes: [Node], followingLogic logic: AdjacentLogic) -> Graph {
        let nodesCopy = nodes.map { Node(label: $0.label, position: $0.position) }
        let graph = Graph(nodes: nodesCopy)

        for node in graph.nodes {
            let connections = graph
                .possibleConnections(for: node)
                .compactMap { possibleNodeConnection in
                    if node.isAdjacent(to: possibleNodeConnection, following: logic) {
                        return possibleNodeConnection
                    }
                    return nil
                }
            graph.addConnections(
                source: node,
                destination: connections
            )
        }

        return graph
    }

    private func performAlgorithm(start: Node) {
        var queue = Queue()
        start.distance = 0
        queue.enqueue(value: start)

        while let current = queue.dequeue() {
            for node in current.connections {
                if node.distance == nil {
                    queue.enqueue(value: node)
                    node.distance = current.distance! + 1
                }
            }
        }
    }
}

private class Graph {
    private(set) var nodes: [Node]

    init(nodes: [Node]) {
        self.nodes = nodes
    }

    func findNode(for value: Position) -> Node? {
        nodes.first { $0.position == value }
    }

    func findNode(for label: String) -> Node? {
        nodes.first { $0.label == label }
    }

    func filter(_ isIncluded: (Node) -> Bool) -> [Node] {
        nodes.filter(isIncluded)
    }

    func addConnections(source: Node, destination: [Node]) {
        for node in destination {
            source.addConnection(node)
        }
    }
}

private extension Graph {
    func possibleConnections(for node: Node) -> [Node] {
        [
            Position(x: node.position.x - 1, y: node.position.y),
            Position(x: node.position.x, y: node.position.y - 1),
            Position(x: node.position.x + 1, y: node.position.y),
            Position(x: node.position.x, y: node.position.y + 1)
        ].compactMap(self.findNode)
    }
}

private struct Queue {

    private var nodes = [Node]()

    mutating func enqueue(value: Node) {
        nodes.append(value)
    }

    mutating func dequeue() -> Node? {
        nodes.isEmpty ? nil : nodes.removeFirst()
    }
}

private struct Position: Equatable {
    let x: Int
    let y: Int
}

private class Node {
    let label: String
    let position: Position
    private(set) var connections: [Node] = []
    var distance: Int?

    init(label: String, position: Position) {
        self.label = label
        self.position = position
    }

    func addConnection(_ node: Node) {
        connections.append(node)
    }
}

private enum AdjacentLogic {
    case upwards
    case downwards
}

private extension Node {
    func isAdjacent(to node: Node, following logic: AdjacentLogic) -> Bool {
        switch logic {
        case .upwards:
            return node.label.equivalent.asciiValue! <= self.label.equivalent.asciiValue! + 1

        case .downwards:
            return node.label.equivalent.asciiValue! >= self.label.equivalent.asciiValue! - 1
        }
    }
}

private extension String {
    var equivalent: Character {
        switch self {
        case "S": return Character("a")
        case "E": return Character("z")
        default: return Character(self)
        }
    }
}
