import ArgumentParser
import Foundation

extension SMC {
    struct Random: AsyncParsableCommand {
        static var configuration = CommandConfiguration(abstract: "get random record")

        func run() async throws -> Void {            
            try await api.random().print()
            
            if SMC.getConfirmation(prompt: "Another one? (Y/n)", default: true) {
                try await run()
            }
        }
    }
}
