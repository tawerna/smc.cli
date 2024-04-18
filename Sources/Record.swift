import Foundation
import HTTPTypes

struct Record: Decodable {
    var id: UInt
    var content: String
    var date: Date
    
    func print(withNumber: Bool = true, withDate: Bool = true) -> Void {
        Swift.print()
        
        if withNumber {
            Swift.print("#", id)
        }

        if withDate {
            Swift.print(date.formatted(date: .long, time: .shortened), terminator: "\n\n")
        }
        
        Swift.print(content, terminator: "\n\n")
    }
}

struct Metadata: Decodable {
    var page: UInt
    var per: UInt
    var total: UInt
    var last: UInt {
        guard per > 0 && total > 0 else {
            return 1
        }
        
        return UInt((Float(total) / Float(per)).rounded(.up))
    }
}

struct Page: Decodable {
    var items: [Record]
    var metadata: Metadata
    
    func print(withNumber: Bool = true, withDate: Bool = true) -> Void {
        Swift.print()
        for record in items {
            record.print(withNumber: withNumber, withDate: withDate)
            
            for _ in 1...9 { Swift.print("-", terminator: "") }
            
            Swift.print()
        }

        Swift.print()

        Swift.print(
            "PAGE:",
            " ",
            metadata.page,
            "/",
            metadata.last,
            separator: "",
            terminator: "\n\n"
        )
    }
}

struct Search: Encodable {
    var query: String
}

class API {
    private let endpoint: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init (endpoint: String = "https://api.tawerna.net/") {
        self.endpoint = endpoint.hasSuffix("/") ? endpoint : endpoint + "/"
        
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    func get(_ number: UInt) async throws -> Record? {
        let (data, _) = try await URLSession.shared.data(from: URL(string: endpoint + "smc/" + String(number))!)

        return try? decoder.decode(Record.self, from: data)
    }

    func random() async throws -> Record {
        let (data, _) = try await URLSession.shared.data(from: URL(string: endpoint + "smc/random")!)

        return try! decoder.decode(Record.self, from: data)
    }

    func page(_ number: UInt = 1) async throws -> Page {
        var request: URLRequest = URLRequest(url: URL(string: endpoint + "smc/")!)
        request.url!.append(queryItems: [
            URLQueryItem(name: "page", value: number < 1 ? "1" : String(number))
        ])

        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try! decoder.decode(Page.self, from: data)
    }
    
    func search(_ query: String, _ number: UInt = 1) async throws -> Page {
        var request: URLRequest = URLRequest(url: URL(string: endpoint + "smc/search")!)

        request.httpMethod = "POST";
        request.httpBody = try! encoder.encode(Search(query: query))

        request.setValue(String(request.httpBody!.count), forHTTPHeaderField: HTTPField.Name.contentLength.rawName)
        request.setValue("application/json", forHTTPHeaderField: HTTPField.Name.contentType.rawName)
        
        request.url!.append(queryItems: [
            URLQueryItem(name: "page", value: number < 1 ? "1" : String(number))
        ])

        let (data, _) = try await URLSession.shared.data(for: request)

        return try! decoder.decode(Page.self, from: data)
    }
}
