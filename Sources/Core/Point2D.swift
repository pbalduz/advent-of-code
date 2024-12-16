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
