import Combine

protocol SearchBooksBusinessLogic {
    func doSomething(request: SearchBooks.SearchBook.Request)
}

protocol SearchBooksDataStore {
    var text: String { get set }
}

class SearchBooksInteractor: SearchBooksBusinessLogic, SearchBooksDataStore {
    
    var text: String = ""
    var presenter: SearchBooksPresentationLogic?
    var worker = SearchBooksNetworkWorker()
    @Published var books: [Book] = []
    private var subscribers = Set<AnyCancellable>()
    // MARK: Do something
    
    func doSomething(request: SearchBooks.SearchBook.Request) {
        worker = SearchBooksNetworkWorker()
        worker.fetchBooks(request: request)
        worker.$books.sink { book in
            self.books = book
        }.store(in: &self.subscribers)
        
//        let response = SearchBooks.SearchBook.Response()
//        presenter?.presentSomething(response: response)
    }
}
