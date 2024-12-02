import Core
import Parsing

public struct Day02: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        let reports = try reportList.parse(data)
        return reports.count(where: { $0.isSafe() })
    }

    public func part2() async throws -> Int {
        let reports = try reportList.parse(data)
        return reports.count(where: { $0.isSafeWithTolerance() })
    }
}

private struct Report {
    let levels: [Int]

    func isSafe() -> Bool {
        let ascendingValid = (0..<levels.count - 1).allSatisfy {
            levels[$0] < levels[$0 + 1] && abs(levels[$0] - levels[$0 + 1]) <= 3
        }
        let descendingValid = (0..<levels.count - 1).allSatisfy {
            levels[$0] > levels[$0 + 1] && abs(levels[$0] - levels[$0 + 1]) <= 3
        }
        return ascendingValid || descendingValid
    }

    func isSafeWithTolerance() -> Bool {
        guard !isSafe() else {
            return true
        }
        for index in levels.indices {
            var copy = levels
            copy.remove(at: index)
            let report = Report(levels: copy)
            if report.isSafe() {
                return true
            }
        }
        return false
    }
}

private let report = Parse(
    input: Substring.self,
    Report.init
) {
    Many {
        Int.parser()
    } separator: {
        " "
    }
}

private let reportList = Many {
    report
} separator: {
    "\n"
}

//extension Sequence {
//    func isSorted(_ isOrdered: (Element, Element) -> Bool) -> Bool {
//        for i in 1..<self.count {
//            if !isOrdered(self[i-1], self[i]) {
//                return false
//            }
//        }
//        return true
//    }
//}
