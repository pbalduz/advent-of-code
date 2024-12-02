import Foundation

public protocol AdventDay: Sendable {
    associatedtype Answer1
    associatedtype Answer2

    static var day: Int { get }

    /// An initializer that uses the provided test data.
    init(data: String)

    /// Computes and returns the answer for part one.
    func part1() async throws -> Answer1

    /// Computes and returns the answer for part two.
    func part2() async throws -> Answer2
}

extension AdventDay {
    public static var day: Int {
        let typeName = String(reflecting: Self.self)
        guard let i = typeName.lastIndex(where: { !$0.isNumber }),
              let day = Int(typeName[i...].dropFirst())
        else {
            fatalError(
        """
        Day number not found in type name: \
        implement the static `day` property \
        or use the day number as your type's suffix (like `Day3`).")
        """)
        }
        return day
    }

    public var day: Int { Self.day }
}
