import Combine
import UIKit

protocol SearchBooksWorker {
    func searchBooks(request: SearchBooks.SearchBook.Request)
}

final class DefaultSearchBooksWorker: SearchBooksWorker {
    private var subscribers = Set<AnyCancellable>()
    
    var pageNumber = 1
    
    @Published var books: [Book] = []
    
    func searchBooks(request: SearchBooks.SearchBook.Request) {
        books.removeAll()
        if request.reload { pageNumber = 1 }
        if request.isPaginating { pageNumber += 1 }
        
        let endpoint = Endpoint.searchBooks(name: request.searchText, page: pageNumber)
        
        DefaultNetworkController.shared.getData(endpoint: endpoint.url.absoluteString, type: Books.self)
            .sink {[weak self] promise in
                switch promise {
                case .failure(let error):
                    print("🔴 Error at \(String(describing: self)) - \(String(describing: error))")
                case .finished:
                    print("🟢 Data Fetched Succesfully")
                }
            } receiveValue: { books in
                if books.books.isEmpty {
                    self.books.removeAll()
                } else {
                    self.books.append(contentsOf: books.books)
                }
                print(books)
            }.store(in: &self.subscribers)
    }
}
