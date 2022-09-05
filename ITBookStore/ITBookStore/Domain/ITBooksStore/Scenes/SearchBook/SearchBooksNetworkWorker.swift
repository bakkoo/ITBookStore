import Combine

protocol DefaultSearchBooksNetworkController: AnyObject {
    func fetchBooks(request: SearchBooks.SearchBook.Request)
}

class SearchBooksNetworkWorker: DefaultSearchBooksNetworkController {
    
    private var subscribers = Set<AnyCancellable>()
    
    @Published var books: [Book] = []
    
    func fetchBooks(request: SearchBooks.SearchBook.Request) {
        let endpoint = Endpoint.searchBooks(name: request.searchText, page: request.page)
        DefaultNetworkController.shared.getData(endpoint: endpoint.url.absoluteString, type: Books.self)
            .sink {[weak self] promise in
                switch promise {
                case .failure(let error):
                    print("🔴 Error at \(String(describing: self)) - \(String(describing: error))")
                case .finished:
                    print("🟢 Data Fetched Succesfully")
                    print(self?.books)
                }
            } receiveValue: { data in
                self.books.append(contentsOf: data.books)
                print(data)
            }.store(in: &self.subscribers)
    }
}
