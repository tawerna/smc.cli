import ArgumentParser
import Foundation

@available(macOS 13, *)
extension SMC {
    struct Random: AsyncParsableCommand {
        static var configuration = CommandConfiguration(abstract: "get random record")

        func run() async throws -> Void {            
            let record = try await api.random()

            print()
            print("#", record.id, terminator: "\n\n")
            print(record.content, terminator: "\n\n")
        }
    }
}
