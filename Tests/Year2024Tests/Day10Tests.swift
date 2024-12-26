import Testing
import Year2024

struct Day010Tests {
    let data = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    @Test
    func part1() async throws {
        let day = Day10(data: data)

        let part1 = try await day.part1()
        #expect(part1 == 36)
    }

    @Test
    func part2() async throws {
        let day = Day10(data: data)

        let part2 = try await day.part2()
        #expect(part2 == 81)
    }
}
