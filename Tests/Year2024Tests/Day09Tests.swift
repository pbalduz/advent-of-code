import Testing
import Year2024

struct Day09Tests {
    let data = "2333133121414131402"

    @Test
    func part1() async throws {
        let day = Day09(data: data)

        let part1 = try await day.part1()
        #expect(part1 == 1928)
    }

    @Test
    func part2() async throws {
        let day = Day09(data: data)

        let part2 = try await day.part2()
        #expect(part2 == 2858)
    }
}
