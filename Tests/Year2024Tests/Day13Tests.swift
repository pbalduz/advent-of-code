import Testing
import Year2024

struct Day13Tests {
    let data = """
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    """

    @Test
    func part1() async throws {
        let day = Day13(data: data)

        let part1 = try await day.part1()
        #expect(part1 == 480)
    }

    @Test
    func part2() async throws {
        let day = Day13(data: data)

        let part2 = try await day.part2()
        #expect(part2 == 875318608908)
    }
}
