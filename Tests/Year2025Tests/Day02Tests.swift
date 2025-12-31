import Testing
import Year2025

struct Day02Tests {
    let data = """
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    """

    @Test
    func part1() async throws {
        let day = Day02(data: data)
        let result = try await day.part1()
        #expect(result == 1227775554)
    }

    @Test
    func part2() async throws {
        let day = Day02(data: data)
        let result = try await day.part2()
        #expect(result == 4174379265)
    }
}
