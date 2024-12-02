import Testing
import Year2024

struct Day02Tests {
    let data = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    @Test
    func part1() async throws {
        let day = Day02(data: data)

        let part1 = try await day.part1()
        #expect(part1 == 2)
    }

    @Test
    func part2() async throws {
        let day = Day02(data: data)

        let part2 = try await day.part2()
        #expect(part2 == 4)
    }
}
