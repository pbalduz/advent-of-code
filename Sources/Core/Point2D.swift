public struct Point2D: Hashable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public func moved(_ direction: Direction, offset: Int = 1) -> Point2D {
        switch direction {
        case .up: Point2D(x: x, y: y - offset)
        case .down: Point2D(x: x, y: y + offset)
        case .left: Point2D(x: x - offset, y: y)
        case .right: Point2D(x: x + offset, y: y)
        }
    }
}

extension Point2D {
    public static func + (lhs: Point2D, rhs: Point2D) -> Point2D {
        Point2D(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }

    public static func - (lhs: Point2D, rhs: Point2D) -> Point2D {
        Point2D(
            x: lhs.x - rhs.x,
            y: lhs.y - rhs.y
        )
    }
}

extension Point2D {
    public enum NeighboursDisplay {
        case cross
        case diagonal
        case square
    }

    public func neighbours(display: NeighboursDisplay) -> [Point2D] {
        switch display {
        case .cross:
            [
                Point2D(x: x - 1, y: y),
                Point2D(x: x + 1, y: y),
                Point2D(x: x, y: y - 1),
                Point2D(x: x, y: y + 1)
            ]

        case .diagonal:
            [
                Point2D(x: x - 1, y: y - 1),
                Point2D(x: x + 1, y: y - 1),
                Point2D(x: x - 1, y: y + 1),
                Point2D(x: x + 1, y: y + 1)
            ]

        case .square:
            [
                Point2D(x: x - 1, y: y - 1),
                Point2D(x: x, y: y - 1),
                Point2D(x: x + 1, y: y - 1),
                Point2D(x: x + 1, y: y),
                Point2D(x: x + 1, y: y + 1),
                Point2D(x: x, y: y + 1),
                Point2D(x: x - 1, y: y + 1),
                Point2D(x: x - 1, y: y)
            ]
        }
    }
}
