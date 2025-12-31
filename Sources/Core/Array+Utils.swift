extension Array where Element: Equatable {
    /// Boolean indicating whether all elements in the array are equal.
    ///
    /// Returns true for empty arrays.
    public var areAllElementsEqual: Bool {
        dropFirst().allSatisfy { $0 == first }
    }
}
