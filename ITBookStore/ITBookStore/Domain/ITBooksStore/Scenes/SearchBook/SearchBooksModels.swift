import UIKit

enum SearchBooks {
    // MARK: Use cases
    
    enum SearchBook {
        
        struct Request {
            let searchText: String
            let page: Int
        }
        
        struct Response {
            let books: Books
        }
        
        struct ViewModel {
            
        }
    }
}
