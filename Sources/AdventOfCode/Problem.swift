import Foundation

protocol Problem {
    associatedtype Input
    associatedtype Output
    func input(from stream: InputStream) throws -> Input
    func process(_ input: Input) async throws -> Output
    func text(from output: Output) -> String
}

extension Problem {
    func run(with inputFile: String) async throws -> String {
        guard
            let url = Bundle.module.resourceURL?
                .appendingPathComponent("Inputs")
                .appendingPathComponent(inputFile)
                .appendingPathExtension("txt"),
            let stream = InputStream(url: url)
        else {
            throw ProblemError.lostInput
        }
        stream.open()
        let input = try input(from: stream)
        stream.close()
        let output = try await process(input)
        return text(from: output)
    }
}

enum ProblemError: Error {
    case lostInput
    case badInput
}
