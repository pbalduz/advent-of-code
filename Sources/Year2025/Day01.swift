import Core
import Foundation
import Parsing

public struct Day01: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }
    
    public func part1() async throws -> Int {
        let operations = try parser.parse(data)
        var zeroCounter = 0
        var counter = 50
        for operation in operations {
            counter = operation(counter).mod(100)
            if counter == 0 {
                zeroCounter += 1
            }
        }
        return zeroCounter
    }

    public func part2() async throws -> Int {
        let operations = try parser.parse(data)
        var counter = 50
        var zeroHits = 0
        for operation in operations {
            let realEnd = operation(counter)
            if realEnd > 99 {
                zeroHits += realEnd / 100
            }
            if realEnd <= 0, counter != 0 {
                zeroHits += abs(realEnd) / 100 + 1
            }
            if realEnd <= 100, counter == 0 {
                zeroHits += abs(realEnd) / 100
            }
                                                            
            counter = realEnd.mod(100)
        }
        return zeroHits
    }
}

extension Int {
    func mod(_ m: Int) -> Int {
        let remainder = self % m
        return remainder >= 0 ? remainder : remainder + m
    }
}

private let parser = Many {
    OneOf {
        Parse {
            "L"
            Int.parser()
        }.map { int in { $0 - int } }
        
        Parse {
            "R"
            Int.parser()
        }.map { int in { $0 + int } }
    }
} separator: {
    "\n"
}
