import UIKit

protocol SearchBooksBusinessLogic {
    func doSomething(request: SearchBooks.SearchBook.Request)
}

protocol SearchBooksDataStore {
    var text: String { get set }
}

class SearchBooksInteractor: SearchBooksBusinessLogic, SearchBooksDataStore {
    
    var text: String = ""
    var presenter: SearchBooksPresentationLogic?
    var worker: SearchBooksWorker?
    
    // MARK: Do something
    
    func doSomething(request: SearchBooks.SearchBook.Request) {
        worker = SearchBooksWorker()
        worker?.fetchBooks(by: text)
//        let response = SearchBooks.SearchBook.Response()
//        presenter?.presentSomething(response: response)
    }
}
