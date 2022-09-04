import UIKit

protocol SearchBooksBusinessLogic {
    func doSomething(request: SearchBooks.Something.Request)
}

protocol SearchBooksDataStore {
    //var name: String { get set }
}

class SearchBooksInteractor: SearchBooksBusinessLogic, SearchBooksDataStore {
    var presenter: SearchBooksPresentationLogic?
    var worker: SearchBooksWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: SearchBooks.Something.Request) {
        worker = SearchBooksWorker()
        worker?.doSomeWork()
        
        let response = SearchBooks.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
