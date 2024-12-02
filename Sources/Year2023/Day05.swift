import Core
import RegexBuilder

public struct Day05: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() -> Any {
        let match = data.wholeMatch(of: regex)
        let seeds = match!.output.1
        let categories = match!.output.2.map(CategoryMap.init)
        return seeds.map { seed in
            categories.reduce(seed) { result, category in
                category.map(result)
            }
        }.min()!
    }

    public func part2() -> Any {
        let match = data.wholeMatch(of: regex)
        let seeds = match!.output.1
            .chunks(ofCount: 2)
            .reduce(into: [Range<Int>]()) { result, range in
                result.append((range.first!..<range.first! + range.last!))
            }
        let categories = match!.output.2.map(CategoryMap.init)
        return seeds
            .flatMap { seed in
                categories.reduce([seed]) { result, category in
                    result.flatMap(category.map)
                }
            }
            .map(\.lowerBound)
            .min()!
    }
}

struct CategoryMap {
    let sourceRanges: [Range<Int>]
    let offsets: [Int]

    init(data: [[Int]]) {
        self.sourceRanges = data.map { ($0[1]..<$0[1] + $0[2]) }
        self.offsets = data.map { $0[0] - $0[1] }
    }

    func map(_ value: Int) -> Int {
        for (sourceRange, offset) in zip(sourceRanges, offsets) {
            if sourceRange.contains(value) {
                return value + offset
            }
        }
        return value
    }

    func map(_ range: Range<Int>) -> [Range<Int>] {
        var mappedRanges = [range]
        for (sourceRange, offset) in zip(sourceRanges, offsets).sorted(by: { $0.0.lowerBound < $1.0.lowerBound }) {
            let last = mappedRanges.removeLast()
            mappedRanges.append(
                contentsOf: mapRange(range: last, source: sourceRange, offset: offset)
            )
            if range.upperBound <= sourceRange.upperBound { break }
        }
        return mappedRanges.sorted(by: { $0.lowerBound < $1.lowerBound })
    }
}

private func mapRange(range: Range<Int>, source: Range<Int>, offset: Int) -> [Range<Int>] {
    guard range.overlaps(source) else {
        return [range]
    }
    let leftOverhead: Range<Int>? = {
        guard range.lowerBound < source.lowerBound else {
            return nil
        }
        return range.lowerBound..<source.lowerBound
    }()
    let rightOverhead: Range<Int>? = {
        guard range.upperBound > source.upperBound else {
            return nil
        }
        return source.upperBound..<range.upperBound
    }()
    let clamped = range.clamped(to: source)
    let contained = clamped.isEmpty ? nil : clamped.lowerBound + offset..<clamped.upperBound + offset

    let mappedRanges = [
        leftOverhead,
        contained,
        rightOverhead
    ]

    return Array(mappedRanges.compacted())
}

private let seedsRegex = Regex {
    TryCapture {
        OneOrMore(.anyNonNewline)
    } transform: {
        String($0)
            .components(separatedBy: " ")
            .compactMap(Int.init)
    }
    OneOrMore(.newlineSequence)
}

private let categoryMapRegex = Regex {
    OneOrMore(.anyNonNewline)
    One(.newlineSequence)
    Repeat(0...) {
        OneOrMore(.anyNonNewline)
        Optionally {
            One(.newlineSequence)
        }
    }
    Optionally {
        One(.newlineSequence)
    }
}

private let regex = Regex {
    seedsRegex
    Capture {
        Repeat(0...) {
            categoryMapRegex
        }
    } transform: {
        $0.matches(of: categoryMapRegex)
            .map { category in
                category.output.components(separatedBy: "\n")
                    .map { line in
                        line.components(separatedBy: " ")
                            .compactMap(Int.init)
                    }
                    .filter { !$0.isEmpty }
        }
    }
}
