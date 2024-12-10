import Testing
import Year2024

struct Day04Tests {
    let data = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    @Test
    func part1() async throws {
        let day = Day04(data: data)

        let part1 = try await day.part1()
        #expect(part1 == 18)
    }

    @Test
    func part2() async throws {
        let day = Day04(data: data)

        let part2 = try await day.part2()
        #expect(part2 == 9)
    }
}
