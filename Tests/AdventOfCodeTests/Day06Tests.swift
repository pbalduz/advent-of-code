import XCTest
@testable import AdventOfCode

final class Day06Tests: XCTestCase {
    let data = """
    Time:      7  15   30
    Distance:  9  40  200
    """

    func testPart1() throws {
        let challenge = Day06(data: data)
        XCTAssertEqual(String(describing: challenge.part1()), "288")
    }

    func testPart2() throws {
        let challenge = Day06(data: data)
        XCTAssertEqual(String(describing: challenge.part2()), "71503")
    }
}
