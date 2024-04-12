import Foundation

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
            if #available(macOS 12.0, *) {
                Swift.print(date.formatted(date: .long, time: .shortened), terminator: "\n\n")
            } else {
                Swift.print(date, terminator: "\n\n")
            }
        }
        
        Swift.print(content, terminator: "\n\n")
    }
}

struct Metadata: Decodable {
    var page: UInt
    var per: UInt
    var total: UInt
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
            String(metadata.page),
            "/",
            String(format: "%.f", (Float(metadata.total) / Float(metadata.per)).rounded(.up)),
            separator: "",
            terminator: "\n\n"
        )
    }
}

struct Search: Encodable {
    var query: String
}

@available(macOS 13.0, *)
class API {
    private var request: URLRequest
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init (endpoint: String = "https://api.tawerna.net/smc/") {
        request = URLRequest(url: URL(string: endpoint)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    func get(_ number: UInt) async throws -> Record? {
        var request: URLRequest = self.request;
        request.url!.append(path: String(number))

        let (data, _) = try await URLSession.shared.data(for: request)

        return try? decoder.decode(Record.self, from: data)
    }

    func random() async throws -> Record {
        var request: URLRequest = self.request;
        request.url!.append(path: "random")

        let (data, _) = try await URLSession.shared.data(for: request)

        return try! decoder.decode(Record.self, from: data)
    }

    func page(_ number: UInt = 1) async throws -> Page {
        let page: String = number < 1 ? "1" : String(number)
        
        var request: URLRequest = self.request;
        request.url!.append(queryItems: [
            URLQueryItem(name: "page", value: page)
        ])

        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try! decoder.decode(Page.self, from: data)
    }
    
    func search(_ query: String, _ number: UInt = 1) async throws -> Page {
        let page: String = number < 1 ? "1" : String(number)
        
        var request: URLRequest = self.request;
        
        request.url!.append(path: "search")
        request.httpMethod = "POST";
        request.httpBody = try! encoder.encode(Search(query: query))

        request.setValue(String(request.httpBody!.count), forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.url!.append(queryItems: [
            URLQueryItem(name: "page", value: page)
        ])

        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try! decoder.decode(Page.self, from: data)
    }
}
