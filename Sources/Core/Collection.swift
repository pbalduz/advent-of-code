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
