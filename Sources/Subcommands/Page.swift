import ArgumentParser
import Foundation

@available(macOS 13, *)
extension SMC {
    struct Page: AsyncParsableCommand {
        static var configuration = CommandConfiguration( abstract: "get all records (paginated)")

        @Argument(help: "page number")
        var number: UInt = 1
        
        func run() async throws -> Void {
            let page = try await api.page(number)

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
