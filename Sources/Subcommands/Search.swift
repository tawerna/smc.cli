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
            let page = try await api.search(query, number)

            print()
            for record in page.data {
                print("#", record.id, terminator: "\n\n")
                print(record.content, terminator: "\n\n")
                
                for _ in 1...9 { print("-", terminator: "") }
                
                print()
            }

            print()
            print("PAGE:", " ", String(page.meta.currentPage), "/", String(page.meta.lastPage), separator: "", terminator: "\n\n")
        }
    }
}
