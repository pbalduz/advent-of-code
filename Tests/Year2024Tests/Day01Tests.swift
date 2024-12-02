import Testing
import Year2024

struct Day01Tests {
    let data = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    @Test
    func part1() async throws {
        let day = Day01(data: data)

        #expect(try await day.part1() == 11)
    }

    @Test
    func part2() async throws {
        let day = Day01(data: data)

        let part2 = try await day.part2()
        #expect(part2 == 31)
    }
}
