import Testing
import Year2024

struct Day06Tests {
    let data = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    @Test
    func part1() async throws {
        let day = Day06(data: data)

        let part1 = try await day.part1()
        #expect(part1 == 41)
    }

    @Test
    func part2() async throws {
        let day = Day06(data: data)

        let part2 = try await day.part2()
        #expect(part2 == 6)
    }
}
