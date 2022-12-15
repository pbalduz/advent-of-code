import Foundation

enum ParsingError: String, Error, CustomStringConvertible {
    case inputFileNotFound

    var description: String { rawValue }
}

public func readFile(_ resource: String, withExtension _extension: String) throws -> String {
    guard let inputFileUrl = Bundle.main.url(
        forResource: resource,
        withExtension: _extension
    ) else {
        throw ParsingError.inputFileNotFound
    }
    return try String(
        contentsOf: inputFileUrl,
        encoding: .utf8
    )
}

public protocol Runnable {
    associatedtype Result: CustomStringConvertible

    func run() throws -> Result
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
