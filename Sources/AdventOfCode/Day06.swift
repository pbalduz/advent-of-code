import RegexBuilder

struct Day06: AdventDay {
    let data: String

    func part1() -> Any {
        let races = data
            .wholeMatch(of: regex)
            .map {
                let times = $0.output.1.matches(of: .positiveInt).map(\.output.1)
                let distances = $0.output.2.matches(of: .positiveInt).map(\.output.1)
                return zip(distances, times).map(Race.init)
            }!
        return races
            .map(\.winsCount)
            .reduce(1, *)
    }

    func part2() -> Any {
        let race = data
            .wholeMatch(of: regex)
            .map {
                Race(
                    recordDistance: Int($0.output.2.filter(\.isNumber))!,
                    time: Int($0.output.1.filter(\.isNumber))!
                )
            }!
        return race.winsCount
    }
}

private struct Race {
    let recordDistance: Int
    let time: Int

    var winsCount: Int {
        let firstWin: Int = {
            (1...time).first { millisecond in
                (time - millisecond) * millisecond > recordDistance
            }!
        }()
        let lastWin: Int = {
            (1...time).reversed().first { millisecond in
                (time - millisecond) * millisecond > recordDistance
            }!
        }()
        return lastWin - firstWin + 1
    }
}

private let regex = Regex {
    "Time:"
    Capture {
        OneOrMore(.any, .reluctant)
    }
    "Distance:"
    Capture {
        OneOrMore(.any)
    }
}
