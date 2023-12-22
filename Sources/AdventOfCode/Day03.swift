import Algorithms
import Foundation
import RegexBuilder

struct Day03: AdventDay {
    let data: String
        
    func part1() -> Any {
        let (numbers, symbols) = mapData()
        let partNumbers = symbols
            .flatMap { symbol in
                let adjacent = Set(symbol.position.adjacent)
                return numbers.filter { !$0.positions.intersection(adjacent).isEmpty }
            }
        return partNumbers
            .uniqued()
            .map(\.value)
            .reduce(0, +)
    }
    
    func part2() -> Any {
        let (numbers, symbols) = mapData()
        let gearRatios = symbols
            .filter { $0.value == "*" }
            .map { symbol in
            let adjacent = Set(symbol.position.adjacent)
            let partNumbers = numbers.filter { !$0.positions.intersection(adjacent).isEmpty }
            guard partNumbers.count == 2 else {
                return 0
            }
            return partNumbers.first!.value * partNumbers.last!.value
        }
        return gearRatios
            .reduce(0, +)
    }
    
    private func mapData() -> ([Number], [Symbol]) {
        data
            .components(separatedBy: "\n")
            .enumerated()
            .reduce(into: ([Number](), [Symbol]())) { result, line in
                result.0.append(
                    contentsOf: line.element.matches(of: .positiveInt).map { match in
                        let startOffset = line.element.offset(of: match.output.0.startIndex)
                        let endOffset = line.element.offset(of: match.output.0.endIndex)
                        let positions = (startOffset..<endOffset).map {
                            Point(x: $0, y: line.offset)
                        }
                        return Number(
                            value: match.output.1,
                            positions: Set(positions)
                        )
                    }
                )
                result.1.append(
                    contentsOf: line.element.matches(of: symbolRegex).map { match in
                        Symbol(
                            value: match.output.1,
                            position: Point(
                                x: line.element.offset(of: match.output.0.startIndex),
                                y: line.offset
                            )
                        )
                    }
                )
            }
    }
}

private struct Number: Hashable {
    let value: Int
    let positions: Set<Point>
}

private struct Symbol: Hashable {
    let value: String
    let position: Point
}

private struct Point: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int
    
    var description: String { "\(x),\(y)" }
    
    var adjacent: [Point] {
        var points = [Point]()
        for _x in (x - 1...x + 1) {
            for _y in (y - 1...y + 1) {
                if _x == x && _y == y { continue }
                points.append(.init(x: _x, y: _y))
            }
        }
        return points
    }
}

private let symbolRegex = Regex {
    TryCapture {
        One(.any)
    } transform: { value -> String? in
        guard 
            String(value) != ".",
            Int(value) == nil
        else { return nil }
        return String(value)
    }
}

extension RegexComponent where Self == Regex<(Substring, Int)> {
    static var positiveInt: Regex<(Substring, Int)> {
        Regex {
            TryCapture {
                OneOrMore(.digit)
            } transform: { Int($0) }
        }
    }
}

extension String {
    func offset(of index: Index) -> Int {
        distance(from: startIndex, to: index)
    }
}
