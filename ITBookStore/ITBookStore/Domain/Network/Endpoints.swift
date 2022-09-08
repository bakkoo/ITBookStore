import Foundation
import UIKit

struct Endpoint {
    var path: String
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.itbook.store"
        components.path = "/1.0" + path
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
    
    static func searchBooks(name: String, page: Int) -> Self {
        return Endpoint(path: "/search/\(name)/\(page)")
    }
    
    static func bookDetails(isbn: String) -> Self {
        return Endpoint(path: "/books\(isbn)")
    }
}

