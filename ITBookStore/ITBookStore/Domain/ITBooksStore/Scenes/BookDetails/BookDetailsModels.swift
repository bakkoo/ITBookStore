import UIKit

enum BookDetails {
  // MARK: Use cases
  
  enum BookDetail {
      
    struct Request {
        let isbn: String
    }
      
    struct Response {
        let book: BookDetailsModel
    }
      
    struct ViewModel {
        let authors: String
        let publisher: String
        let rating: String
        let year: String
        let description: String
    }
  }
}
