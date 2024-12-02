import ArgumentParser
import Core
import Foundation
import Year2024

// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
    Day01()
]

@main
struct AdventOfCode: AsyncParsableCommand {
    @Argument(help: "The day of the challenge. For December 1st, use '1'.")
    var day: Int?

    @Flag(help: "Benchmark the time taken by the solution")
    var benchmark: Bool = false

    /// The selected day, or the latest day if no selection is provided.
    var selectedChallenge: any AdventDay {
        get throws {
            if let day {
                if let challenge = allChallenges.first(where: { $0.day == day }) {
                    return challenge
                } else {
                    throw ValidationError("No solution found for day \(day)")
                }
            } else {
                return latestChallenge
            }
        }
    }

    /// The latest challenge in `allChallenges`.
    var latestChallenge: any AdventDay {
        allChallenges.max(by: { $0.day < $1.day })!
    }

    func run(part: () async throws -> Any, named: String) async -> Duration {
        var result: Result<Any, Error> = .success("<unsolved>")
        let timing = await ContinuousClock().measure {
            do {
                result = .success(try await part())
            } catch {
                result = .failure(error)
            }
        }
        switch result {
        case .success(let success):
            print("\(named): \(success)")
        case .failure(let failure):
            print("\(named): Failed with error: \(failure)")
        }
        return timing
    }

    func run() async throws {
        let challenge = try selectedChallenge
        print("Executing Advent of Code challenge \(challenge.day)...")

        let timing1 = await run(part: challenge.part1, named: "Part 1")
        let timing2 = await run(part: challenge.part2, named: "Part 2")

        if benchmark {
            print("Part 1 took \(timing1), part 2 took \(timing2).")
            #if DEBUG
                print("Looks like you're benchmarking debug code. Try swift run -c release")
            #endif
        }
    }
}

extension AdventDay {
    /// An initializer that loads the test data from the corresponding data file.
    public init() {
        self.init(data: Self.loadData(challengeDay: Self.day))
    }

    static func loadData(challengeDay: Int) -> String {
        let dayString = String(format: "%02d", challengeDay)
        let dataFilename = "Day\(dayString)"
        let dataURL = Bundle.module.url(
            forResource: dataFilename,
            withExtension: "txt",
            subdirectory: "Data")

        guard let dataURL,
              let data = try? String(contentsOf: dataURL)
        else {
            fatalError("Couldn't find file '\(dataFilename).txt' in the 'Data' directory.")
        }

        // On Windows, line separators may be CRLF. Converting to LF so that \n
        // works for string parsing.
        return data.replacingOccurrences(of: "\r", with: "")
    }
}
