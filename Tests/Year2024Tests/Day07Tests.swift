import Testing
import Year2024

struct Day07Tests {
    let data = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

    @Test
    func part1() async throws {
        let day = Day07(data: data)

        let part1 = try await day.part1()
        #expect(part1 == 3749)
    }

    @Test
    func part2() async throws {
        let day = Day07(data: data)

        let part2 = try await day.part2()
        #expect(part2 == 11387)
    }
}
