import ArgumentParser
import Foundation
import OpenAPIURLSession

let client = Client(
    serverURL: try! Servers.server1(),
    transport: URLSessionTransport()
)

@main
struct SMC: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Tawerniane Śmiechały",
        subcommands: [Random.self, Get.self, Page.self, Search.self],
        defaultSubcommand: Random.self
    )
    
    static func getConfirmation(prompt: String, default: Bool) -> Bool {
        print(prompt, terminator: " ")

        let line = readLine()!

        if line.caseInsensitiveCompare("n") == .orderedSame || line.caseInsensitiveCompare("no") == .orderedSame {
            return false
        }
        if line.caseInsensitiveCompare("y") == .orderedSame || line.caseInsensitiveCompare("yes") == .orderedSame {
            return true
        }

        return `default`
    }
}
