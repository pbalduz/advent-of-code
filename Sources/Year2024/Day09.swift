import Collections
import Core
import Parsing

public struct Day09: AdventDay {
    let data: String

    public init(data: String) {
        self.data = data
    }

    public func part1() async throws -> Int {
        let parser = SimpleDiskParser()
        var disk = try parser.parse(data)

        var fileIndices = Deque(
            disk.indexed().compactMap { $0.element != nil ? $0.index : nil }
        )
        var freeIndices = Deque(
            disk.indexed().compactMap { $0.element == nil ? $0.index : nil }
        )

        while let fileIndex = fileIndices.popLast(), let freeIndex = freeIndices.popFirst() {
            if fileIndex < freeIndex { break }

            disk.swapAt(freeIndex, fileIndex)
            fileIndices.prepend(freeIndex)
            freeIndices.append(fileIndex)
        }

//        print(try parser.print(disk))

        return disk.enumerated().reduce(0) {
            $0 + $1.offset * ($1.element ?? 0)
        }
    }

    public func part2() async throws -> Int {
        let parser = DiskSpacesParser()
        let disk = try parser.parse(data)

        var files = disk.reduce(into: [Int: Range<Int>]()) {
            if let fileId = $1.fileId {
                $0[fileId] = $1.range
            }
        }

        var freeSpaces = disk.compactMap {
            if $0.fileId == nil {
                $0.range
            } else { nil }
        }

        for fileId in files.keys.sorted().reversed() {
            for freeIndex in freeSpaces.indices {
                let file = files[fileId]!
                let freeSpace = freeSpaces[freeIndex]
                if freeSpace.upperBound <= file.lowerBound, file.count <= freeSpace.count {
                    files[fileId] = freeSpace.startIndex..<freeSpace.startIndex + file.count

                    if file.count < freeSpace.count {
                        freeSpaces[freeIndex] = files[fileId]!.upperBound..<freeSpace.upperBound
                    } else {
                        freeSpaces.remove(at: freeIndex)
                    }

                    break
                }
            }
        }

//        var output = [DiskSpace]()
//        output.append(
//            contentsOf: files.reduce(into: [DiskSpace]()) {
//                $0.append(
//                    DiskSpace(fileId: $1.key, range: $1.value)
//                )
//            }
//        )
//        output.append(
//            contentsOf: freeSpaces.map { DiskSpace(fileId: nil, range: $0) }
//        )
//        print(try parser.print(output))

        return files.reduce(0) { result, element in
            result + element.value.reduce(0, +) * element.key
        }
    }
}

private struct SimpleDiskParser: ParserPrinter {
    func parse(_ input: inout Substring) throws -> [Int?] {
        input.enumerated().flatMap { offset, element in
            let number = element.wholeNumberValue!
            input.removeFirst()
            return (0..<number).map { _ in
                offset.isEven ? offset / 2 : nil
            }
        }
    }

    func print(_ output: [Int?], into input: inout Substring) throws {
        output.forEach { value in
            input.append(contentsOf: value.map { "\($0)" } ?? ".")
        }
    }
}

private struct DiskSpace {
    let fileId: Int?
    var range: Range<Int>
}

private struct DiskSpacesParser: ParserPrinter {
    func parse(_ input: inout Substring) throws -> [DiskSpace] {
        var currentOffset = 0
        return input.enumerated().map { offset, element in
            let number = element.wholeNumberValue!
            defer { currentOffset += number }
            input.removeFirst()
            return DiskSpace(
                fileId: offset.isEven ? offset / 2 : nil,
                range: currentOffset..<currentOffset + number
            )
        }
    }

    func print(_ output: [DiskSpace], into input: inout Substring) throws {
        let max = output.max(by: { $0.range.upperBound < $1.range.upperBound })
        var string = String(repeating: ".", count: max?.range.upperBound ?? 0)
        output.forEach { diskSpace in
            if let fileId = diskSpace.fileId {
                let startIndex = string.index(string.startIndex, offsetBy: diskSpace.range.lowerBound)
                let endIndex = string.index(string.startIndex, offsetBy: diskSpace.range.upperBound)
                string.replaceSubrange(
                    startIndex..<endIndex,
                    with: String(repeating: "\(fileId)", count: diskSpace.range.count)
                )
            }
        }
        input = string[...]
    }
}
