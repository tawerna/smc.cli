import ArgumentParser
import Foundation

extension SMC {
    struct Get: AsyncParsableCommand {
        static var configuration = CommandConfiguration(abstract: "get record by ID")

        @Argument(help: "record number/ID")
        var number: UInt

        func run() async throws -> Void {
            let response = try await client.getSingleSMC(
                Operations.getSingleSMC.Input(
                    path: Operations.getSingleSMC.Input.Path(id: Int(number))
                )
            )
            
            switch response {
            case .ok(_):
                try response.ok.body.json.print(withNumber: false)
            case .notFound(_):
                print(try response.notFound.body.json.message!, terminator: "\n\n")
            default:
                print("unexpected response", terminator: "\n\n")
            }
        }
    }
}
