import ArgumentParser
import Foundation

extension SMC {
    struct Random: AsyncParsableCommand {
        static var configuration = CommandConfiguration(abstract: "get random record")

        func run() async throws -> Void {            
            try await api.random().print()
        }
    }
}
