extension String {
    /// An array containing the individual lines of the string,
    /// separated by newline characters.
    public var lines: [String] {
        components(separatedBy: "\n")
    }

    /// Returns the maximum character in the string that satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes a character and returns `true`
    ///   if the character should be considered.
    public func max(where predicate: (Character) -> Bool) -> Character? {
        guard let max = self.max() else { return nil }

        if !predicate(max) {
            guard let maxIndex = firstIndex(of: max) else { return nil }
            let beforeMax = self[startIndex..<maxIndex]
            let afterMax = self[self.index(after: maxIndex)..<endIndex]
            return beforeMax.appending(afterMax).max(where: predicate)
        }

        return max
    }
    
    /// Returns the lexicographically largest substring of characters of length k while
    /// preserving the original order.
    ///
    /// The following example generates the largest substring of length 12
    /// and print its value:
    ///
    ///     let string = "818181911112111"
    ///     let largest = string.largestDigits(length: 12)
    ///     print(largest)
    ///     // Prints "888911112111"
    ///
    /// - Parameter length: The number of characters of the returned subsequence.
    public func largestDigits(length: Int) -> String {
        guard length > 0 else { return "" }

        let max = self.max {
            guard let index = self.firstIndex(of: $0) else { return false }
            return self[index...].count >= length
        }

        guard
            let max,
            let maxIndex = firstIndex(of: max)
        else { return "" }

        let index = index(after: maxIndex)
        let substring = self[index...]

        return String(max) + String(substring).largestDigits(length: length - 1)
    }
}
