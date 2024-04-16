import ArgumentParser
import Foundation

extension SMC {
    struct Get: AsyncParsableCommand {
        static var configuration = CommandConfiguration(abstract: "get record by ID")

        @Argument(help: "record number/ID")
        var number: UInt

        func run() async throws -> Void {
            if let record = try await api.get(number) {
                record.print(withNumber: false)
            } else {
                print("no record by that number/ID", terminator: "\n\n")
            }
        }
    }
}
