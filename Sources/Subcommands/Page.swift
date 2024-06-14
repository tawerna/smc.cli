import ArgumentParser
import Foundation

extension SMC {
    struct Page: AsyncParsableCommand {
        static var configuration = CommandConfiguration( abstract: "get all records (paginated)")

        @Argument(help: "page number")
        var number: UInt = 1
        
        mutating func run() async throws -> Void {
            let response = try await client.listSMC(
                Operations.listSMC.Input(
                    query: Operations.listSMC.Input.Query(
                        page: Int(number)
                    )
                )
            )
            
            let page = try response.ok.body.json;

            page.print()
            
            guard number < page.metadata!.last else {
                return
            }

            if SMC.getConfirmation(prompt: "Next Page? (y/N)", default: false) {
                number += 1
                try await run()
            }
        }
        
        private func isConfirmation(_ line: String) -> Bool {
            if line.caseInsensitiveCompare("y") == .orderedSame {
                return true
            }
            if line.caseInsensitiveCompare("yes") == .orderedSame {
                return true
            }

            return false
        }
    }
}
