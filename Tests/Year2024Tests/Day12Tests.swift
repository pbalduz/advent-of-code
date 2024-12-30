import Testing
import Year2024

struct Day12Tests {
    let data = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

    @Test
    func part1() async throws {
        let day = Day12(data: data)

        let part1 = try await day.part1()
        #expect(part1 == 1930)
    }

    @Test
    func part2() async throws {
        let day = Day12(data: data)

        let part2 = try await day.part2()
        #expect(part2 == 1206)
    }
}
