extension Sequence where Element: Hashable {
    public func occurrences() -> [Element: Int] {
        Dictionary(
            grouping: self,
            by: { $0 }
        )
        .mapValues(\.count)
    }
}
