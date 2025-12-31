extension Collection {
    /// Splits the collection into an array of subsequences, each with a specified maximum length.
    /// - Parameter length: The maximum number of elements each subsequence should contain.
    /// - Returns: An array of `SubSequence` objects.
    public func split(every length: Int) -> [SubSequence] {
        return stride(from: 0, to: count, by: length).map { position in
            self[position..<position + length]
        }
    }

    /// Accesses a contiguous subrange of the collection's elements using an integer range.
    ///
    /// This subscript allows for slicing the collection with standard integer offsets
    /// rather than manual `Index` manipulation.
    ///
    /// - Parameter bounds: A range representing the zero-based offsets of the collection's
    ///  elements. The bounds of the range must be valid between zero and the collection's count.
    ///
    /// - Complexity: O(n), where n is the offset from the start of the collection, as it requires
    /// traversing the collection to find the indices.
    public subscript(_ bounds: Range<Int>) -> SubSequence {
        let length = bounds.upperBound - bounds.lowerBound
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(start, offsetBy: length, limitedBy: endIndex) ?? endIndex
        return self[start..<end]
    }
}

extension RangeReplaceableCollection {
    public func combinations(count: Int) -> [Self] {
        repeatElement(self, count: count)
            .reduce([.init()]) { result, element in
                result.flatMap { elements in
                    element.map { elements + CollectionOfOne($0) }
                }
            }
    }
}
