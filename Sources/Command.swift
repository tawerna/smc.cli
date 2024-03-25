import ArgumentParser
import Foundation

@available(macOS 13.0, *)
let api = API()

@available(macOS 13, *)
@main
struct SMC: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Tawerniane Śmiechały",
        subcommands: [Random.self, Get.self, Page.self, Search.self],
        defaultSubcommand: Random.self
    )
}
