import ArgumentParser
import Foundation

@available(macOS 13, *)
extension SMC {
    struct Page: AsyncParsableCommand {
        static var configuration = CommandConfiguration( abstract: "get all records (paginated)")

        @Argument(help: "page number")
        var number: UInt = 1
        
        func run() async throws -> Void {
            try await api.page(number).print()
        }
    }
}
