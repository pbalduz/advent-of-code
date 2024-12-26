public struct Array2D<Element: Sendable>: Sendable {
    public let columns: Int
    public let rows: Int
    private var storage: [Element]

    public init(
        _ data: [Element],
        rows: Int,
        columns: Int
    ) {
        self.storage = data
        self.columns = columns
        self.rows = rows
    }

    public init(
        initialValue: Element,
        rows: Int,
        columns: Int
    ) {
        self.storage = [Element](repeating: initialValue, count: rows * columns)
        self.columns = columns
        self.rows = rows
    }
}

extension Array2D {
    public subscript(point: Point2D) -> Element {
        get { storage[point.y * columns + point.x] }
        set { storage[point.y * columns + point.x] = newValue }
    }

    public subscript(safe point: Point2D) -> Element? {
        get {
            guard
                point.x >= 0,
                point.x < columns,
                point.y >= 0,
                point.y < rows
            else { return nil }
            return storage[point.y * columns + point.x]
        }
        set {
            guard let newValue else { return }
            storage[point.y * columns + point.x] = newValue
        }
    }
}

extension Array2D: Collection {
    public typealias Index = Int

    public typealias Indices = Range<Int>

    public typealias Iterator = IndexingIterator<[Element]>

    public var startIndex: Int {
        storage.startIndex
    }

    public var endIndex: Int {
        storage.endIndex
    }

    public var indices: Range<Int> {
        storage.indices
    }

    public func index(after i: Int) -> Int {
        storage.index(after: i)
    }

    public subscript(index: Int) -> Element {
        storage[index]
    }

    public func makeIterator() -> IndexingIterator<[Element]> {
        storage.makeIterator()
    }
}

extension Array2D {
    public func firstPoint(where predicate: (Self.Element) throws -> Bool) rethrows -> Point2D? {
        try firstIndex(where: predicate).map(point)
    }

    public func hasPoint(_ point: Point2D) -> Bool {
        point.x >= .zero &&
        point.x < columns &&
        point.y >= .zero &&
        point.y < rows
    }
}

extension Array2D {
    public func point(for i: Array<Element>.Index) -> Point2D {
        let row = i / rows
        let column = i % columns
        return Point2D(
            x: column,
            y: row
        )
    }

    public func index(for point: Point2D) -> Array<Element>.Index {
        point.y * columns + point.x
    }
}

extension Array2D {
    public init(
        _ string: String,
        transform: (Character) -> Element = { $0 }
    ) {
        let lines = string.components(separatedBy: "\n")
        let data = lines.flatMap { $0.map(transform) }
        self.init(
            data,
            rows: lines.count,
            columns: lines[0].count
        )
    }

    public init(
        _ string: String,
        transform: (Point2D, Character) -> Element
    ) {
        let lines = string.components(separatedBy: "\n")
        let data = lines.enumerated().flatMap { lineOffset, line in
            line.enumerated().map { charOffset, char in
                let point = Point2D(
                    x: charOffset,
                    y: lineOffset
                )
                return transform(point, char)
            }
        }
        self.init(
            data,
            rows: lines.count,
            columns: lines[0].count
        )
    }
}
}
