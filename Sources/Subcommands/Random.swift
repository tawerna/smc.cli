import ArgumentParser
import Foundation

@available(macOS 13, *)
extension SMC {
    struct Random: AsyncParsableCommand {
        static var configuration = CommandConfiguration(abstract: "get random record")

        func run() async throws -> Void {            
            try await api.random().print()
        }
    }
}
