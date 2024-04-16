import ArgumentParser
import Foundation

let api = API()

@main
struct SMC: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Tawerniane Śmiechały",
        subcommands: [Random.self, Get.self, Page.self, Search.self],
        defaultSubcommand: Random.self
    )
}
