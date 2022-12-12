import Foundation
import RegexBuilder

public struct Day7: Runnable {
    
    public struct Result: CustomStringConvertible {
        let size1: Int
        let size2: Int

        public var description: String {
            """
            Total size for directories of at most 100_000: \(size1)
            Smallest directory to remove: \(size2)
            """
        }
    }

    public init() { }

    public func run() throws -> Result {
        let content = try readFile("day7-input", withExtension: "txt")
        
        let root = Directory(name: "/")
        var current: Directory = root
        
        let matches = content.matches(of: regex)
        for match in matches {
            if let command = match.1, let directoryName = match.2 {
                if command == "cd", case let directoryName?? = directoryName {
                    if directoryName == "..", let parent = current.parent {
                        current = parent
                    }
                    if let dir = current.findDirectory(String(directoryName)) {
                        current = dir
                    }
                }
            }
            if let directoryName = match.3 {
                let dir = Directory(name: String(directoryName), parent: current)
                current.children.append(dir)
            }
            if let fileSize = match.4, let fileName = match.5 {
                let file = File(name: String(fileName), size: Int(fileSize) ?? 0)
                current.files.append(file)
            }
        }
        
        let size1 = root
            .sizesTree
            .filter { $0 <= 100_000 }
            .reduce(0, +)
        
        let totalSizeAvailable = 70_000_000
        let sizeNeeded = 30_000_000
        let freeMemory = totalSizeAvailable - root.size

        let size2 = root
            .sizesTree
            .filter { $0 + freeMemory >= sizeNeeded }
            .min()
        
        return Result(
            size1: size1,
            size2: size2 ?? 0
        )
    }
}

let commandRegex = Regex {
    "$"
    OneOrMore(.whitespace)
    Capture {
        OneOrMore(.word)
    }
    ChoiceOf {
        Anchor.endOfLine
        Optionally {
            OneOrMore(.whitespace)
            Capture {
                OneOrMore(.anyNonNewline)
            }
        }
    }
}

let directoryRegex = Regex {
    "dir"
    OneOrMore(.whitespace)
    Capture {
        OneOrMore(.word)
    }
}

let fileRegex = Regex {
    Capture {
        OneOrMore(.digit)
    }
    OneOrMore(.whitespace)
    Capture {
        OneOrMore(.anyNonNewline)
    }
}

let regex = Regex {
    ChoiceOf {
        commandRegex
        directoryRegex
        fileRegex
    }
}

class Directory {
    let name: String
    var children: [Directory]
    var files: [File]
    
    weak var parent: Directory?
    
    var size: Int {
        let filesSize = files.map(\.size).reduce(0, +)
        return children.map(\.size).reduce(filesSize, +)
    }
    
    var sizesTree: [Int] {
        [size] + children.flatMap(\.sizesTree)
    }

    init(name: String, parent: Directory? = nil) {
        self.name = name
        self.parent = parent
        self.children = []
        self.files = []
    }
    
    func findDirectory(_ directoryName: String) -> Directory? {
        children.first { $0.name == directoryName }
    }
}

class File {
    let name: String
    let size: Int
    
    init(name: String, size: Int) {
        self.name = name
        self.size = size
    }
}
