import Testing
import Year2024

struct Day011Tests {
    let data = "125 17"

    @Test
    func part1() async throws {
        let day = Day11(data: data)

        let part1 = try await day.part1()
        #expect(part1 == 55312)
    }

    @Test
    func part2() async throws {
        let day = Day11(data: data)

        let part2 = try await day.part2()
        #expect(part2 == 65601038650482)
    }
}
