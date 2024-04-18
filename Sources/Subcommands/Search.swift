import ArgumentParser
import Foundation

extension SMC {
    struct Search: AsyncParsableCommand {
        static var configuration = CommandConfiguration( abstract: "search for records (paginated)")

        @Argument(help: "search query")
        var query: String
        
        @Option(name: [.customLong("page"), .customShort("p")], help: "page number")
        var number: UInt = 1
        
        mutating func run() async throws -> Void {
            let page = try await api.search(query, number)
            page.print()
            
            guard number < page.metadata.last else {
                return
            }

            if SMC.getConfirmation(prompt: "Next Page? (Y/n)", default: true) {
                number += 1
                try await run()
            }
        }
        
        private func isConfirmation(_ line: String) -> Bool {
            if line.caseInsensitiveCompare("n") == .orderedSame {
                return false
            }
            if line.caseInsensitiveCompare("no") == .orderedSame {
                return false
            }

            return true
        }
    }
}
