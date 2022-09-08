import UIKit

enum SearchBooks {
    // MARK: Use cases
    
    enum SearchBook {
        
        struct Request {
            let searchText: String
            let isPaginating: Bool
            let reload: Bool
        }
        
        struct Response {
            let book: Book
        }
        
        struct ViewModel {
            let image: UIImage?
            let title: String
        }
    }
}
