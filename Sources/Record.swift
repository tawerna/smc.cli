import Foundation

struct Record: Decodable {
    var id: Int
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

struct Links: Decodable {
    var first: String?
    var last: String?
    var prev: String?
    var next: String?
}

struct Meta: Decodable {
    var currentPage: UInt
    var from: UInt?
    var lastPage: UInt
    var path: String
    var perPage: UInt
    var to: UInt?
    var total: UInt
}

struct Page: Decodable {
    var data: [Record]
    var links: Links
    var meta: Meta
    
    func print(withNumber: Bool = true, withDate: Bool = true) -> Void {
        Swift.print()
        for record in data {
            record.print(withNumber: withNumber, withDate: withDate)
            
            for _ in 1...9 { Swift.print("-", terminator: "") }
            
            Swift.print()
        }

        Swift.print()
        Swift.print("PAGE:", " ", String(meta.currentPage), "/", String(meta.lastPage), separator: "", terminator: "\n\n")
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
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
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
//        request.addValue("charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.url!.append(queryItems: [
            URLQueryItem(name: "page", value: page)
        ])

        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try! decoder.decode(Page.self, from: data)
    }
}
