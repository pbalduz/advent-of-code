import XCTest
@testable import AdventOfCode

final class Day00Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    """

    func testPart1() throws {
        let challenge = Day01(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "0")
    }

    func testPart2() throws {
        let challenge = Day01(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "0")
    }
}
