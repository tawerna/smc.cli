import ArgumentParser
import Foundation

@available(macOS 13, *)
extension SMC {
    struct Search: AsyncParsableCommand {
        static var configuration = CommandConfiguration( abstract: "search for records (paginated)")

        @Argument(help: "search query")
        var query: String
        
        @Option(name: [.customLong("page"), .customShort("p")], help: "page number")
        var number: UInt = 1
        
        func run() async throws -> Void {
            try await api.search(query, number).print()
        }
    }
}
