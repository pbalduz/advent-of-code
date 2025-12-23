import Testing
import Year2025

struct Day01Tests {
    let data = """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

    @Test
    func part1() async throws {
        let day = Day01(data: data)
        #expect(try await day.part1() == 3)
    }

    @Test
    func part2() async throws {
        let day = Day01(data: data)
        let zeroHits = try await day.part2()
        #expect(zeroHits == 6)
    }
}
