@main
struct App {
    static func main() async throws {
        [
            try await Day1().run(with: "1"),
            try await Day2().run(with: "2"),
            try await Day3().run(with: "3"),
            try await Day4().run(with: "4"),
            try await Day5().run(with: "5"),
        ]
            .enumerated()
            .forEach { (offset, element) in
                print("Day \(offset + 1):\t\(element)")
            }
    }
}
