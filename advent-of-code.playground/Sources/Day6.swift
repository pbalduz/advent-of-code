import Foundation

public struct Day6: Runnable {
    
    typealias Marker = (Character, Int)

    public struct Result: CustomStringConvertible {
        let packetMarker: Marker
        let messageMarker: Marker

        public var description: String {
            """
            Packet maker '\(packetMarker.0)' at position \(packetMarker.1)
            Message maker '\(messageMarker.0)' at position \(messageMarker.1)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let content = try! readFile("day6-input", withExtension: "txt")
        
        func findMarker(length: Int) -> Marker? {
            let initialLengthRange = ..<content.index(content.startIndex, offsetBy: length)
            var chars = content[initialLengthRange]
            for (offset, char) in content.enumerated().dropFirst(length) {
                if Set(chars).count == length {
                    return (char, offset)
                }
                chars.removeFirst()
                chars.append(char)
            }
            return nil
        }

        return Result(
            packetMarker: findMarker(length: 4)!,
            messageMarker: findMarker(length: 14)!
        )
    }
}
