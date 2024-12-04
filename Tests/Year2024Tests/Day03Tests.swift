import Testing
import Year2024

struct Day03Tests {
    @Test
    func part1() async throws {
        let day = Day03(data: "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")

        let part1 = try await day.part1()
        #expect(part1 == 161)
    }

    @Test
    func part2() async throws {
        let day = Day03(data: "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")

        let part2 = try await day.part2()
        #expect(part2 == 48)
    }
}
