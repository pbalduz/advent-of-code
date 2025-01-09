import Foundation

extension Double {
    /// A Boolean value indicating whether this
    /// instance is an integer.
    public var isInteger: Bool {
        floor(self) == self
    }
}

/// Solves a two variable system of linear equations using Cramer's Rule.
public func cramersRule(
    _ pair1: PairOf<Double>,
    _ pair2: PairOf<Double>,
    _ constants: PairOf<Double>
) -> PairOf<Double>? {
    let det = pair1.first * pair2.second - pair1.second * pair2.first
    guard det != .zero else {
        return nil
    }
    let detX = constants.first * pair2.second - pair1.second * constants.second
    let detY = pair1.first * constants.second - constants.first * pair2.first
    return Pair(
        first: detX / det,
        second: detY / det
    )
}
