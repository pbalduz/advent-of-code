import Foundation

let dayChallenge: any Runnable = Day1()

do {
    let result = try dayChallenge.run()
    print(result)
} catch {
    print("Found error:", error)
}
