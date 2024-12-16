public enum Direction {
    case up, down, left, right

    public func turn(_ rotation: Rotation) -> Direction {
        switch rotation {
        case .clockwise:
            switch self {
            case .up: .right
            case .down: .left
            case .left: .up
            case .right: .down
            }

        case .counterClockwise:
            switch self {
            case .up: .left
            case .down: .right
            case .left: .down
            case .right: .up
            }
        }
    }
}

public enum Rotation {
    case clockwise, counterClockwise
}
