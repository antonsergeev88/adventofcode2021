import Foundation

@main
struct App {
    static func main() async throws {
        let processors: [DayProcessor] = [
            Day1(),
            Day2(),
            Day3(),
            Day4(),
            Day5(),
            Day6(),
            Day7(),
            Day8(),
            Day9(),
            Day10(),
            Day11(),
            Day12(),
            Day13(),
            Day14(),
        ]
        
        for processor in processors {
            let start = Date()
            let result = try await processor.process()
            print("Day \(processor.dayNumber) (\(Int(-start.timeIntervalSinceNow * 1_000)) ms)\n\tPart 1: \(result.first)\n\tPart 2: \(result.second)")
        }
    }
}
