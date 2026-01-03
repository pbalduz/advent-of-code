import Testing
@testable import Year2025

struct Day03Tests {
    let data = """
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """

    @Test
    func part1() async throws {
        let day = Day03(data: data)
        let result = try await day.part1()
        #expect(result == 357)
    }

    @Test
    func part2() async throws {
        let day = Day03(data: data)
        let result = try await day.part2()
        #expect(result == 3121910778619)
    }

    @Test(arguments: BatteryTest.testValues)
    func largestDigits(test: BatteryTest) async throws {
        let substring = test.value.largestDigits(length: test.length)
        #expect(substring == test.expected)
    }
}

struct BatteryTest {
    let value: String
    let length: Int
    let expected: String

    static let testValues: [BatteryTest] = [
        .init(value: "987654321111111", length: 2, expected: "98"),
        .init(value: "811111111111119", length: 2, expected: "89"),
        .init(value: "234234234234278", length: 2, expected: "78"),
        .init(value: "818181911112111", length: 2, expected: "92"),
        .init(value: "987654321111111", length: 12, expected: "987654321111"),
        .init(value: "811111111111119", length: 12, expected: "811111111119"),
        .init(value: "234234234234278", length: 12, expected: "434234234278"),
        .init(value: "818181911112111", length: 12, expected: "888911112111")
    ]
}
