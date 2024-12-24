import _math

extension Int {
    /// A Boolean value indicating whether this
    /// integer is even.
    public var isEven: Bool {
        self % 2 == 0
    }

    /// The number of single digits in an integer.
    public var digitsCount: Int {
        if self == 0 { return 1 }
        return Int.init(log10(Double(abs(self)))) + 1
    }

    /// Concatenates two integers into a single one.
    public static func || (lhs: Int, rhs: Int) -> Int {
        let digits = rhs.digitsCount
        return (lhs * Int(pow(10, Double(digits)))) + rhs
    }
}
