import Core
import Parsing

public struct Day13: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        let machines = try MachinesParser().parse(data)
        return machines
            .map { machine in
                cramersRule(
                    Pair(first: machine.button1.first, second: machine.button2.first),
                    Pair(first: machine.button1.second, second: machine.button2.second),
                    machine.prize
                )
            }
            .reduce(0) { result, pair in
                guard
                    let pair,
                    pair.first.isInteger,
                    pair.second.isInteger,
                    pair.first >= 0,
                    pair.first <= 100,
                    pair.second >= 0,
                    pair.second <= 100
                else {
                    return result
                }
                return result + Int(pair.first * 3 + pair.second)
            }
    }

    public func part2() async throws -> Int {
        let machines = try MachinesParser().parse(data)
        return machines
            .map { machine in
                cramersRule(
                    Pair(first: machine.button1.first, second: machine.button2.first),
                    Pair(first: machine.button1.second, second: machine.button2.second),
                    Pair(first: 10000000000000 + machine.prize.first, second: 10000000000000 + machine.prize.second)
                )
            }
            .reduce(0) { result, pair in
                guard
                    let pair,
                    pair.first.isInteger,
                    pair.second.isInteger,
                    pair.first >= 0,
                    pair.second >= 0
                else {
                    return result
                }
                return result + Int(pair.first * 3 + pair.second)
            }
    }
}

private struct ButtonParser: Parser {
    var body: some Parser<Substring, PairOf<Double>> {
        Parse(PairOf<Double>.init) {
            "Button "
            OneOf {
                "A"
                "B"
            }
            ": X+"
            Double.parser()
            ", Y+"
            Double.parser()
        }
    }
}

private struct PrizeParser: Parser {
    var body: some Parser<Substring, PairOf<Double>> {
        Parse(PairOf<Double>.init) {
            "Prize: X="
            Double.parser()
            ", Y="
            Double.parser()
        }
    }
}

private struct Machine {
    let button1: PairOf<Double>
    let button2: PairOf<Double>
    let prize: PairOf<Double>
}

private struct MachineParser: Parser {
    var body: some Parser<Substring, Machine> {
        Parse {
            Machine(button1: $0[0], button2: $0[1], prize: $0[2])
        } with: {
            Many(3) {
                OneOf {
                    ButtonParser()
                    PrizeParser()
                }
            } separator: {
                "\n"
            }
        }
    }
}

private struct MachinesParser: Parser {
    var body: some Parser<Substring, [Machine]> {
        Many {
            MachineParser()
        } separator: {
            "\n\n"
        }
    }
}
