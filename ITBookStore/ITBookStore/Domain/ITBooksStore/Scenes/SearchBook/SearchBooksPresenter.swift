import UIKit

protocol SearchBooksPresentationLogic {
    func presentSomething(response: SearchBooks.SearchBook.Response)
}

class SearchBooksPresenter: SearchBooksPresentationLogic {
    weak var viewController: SearchBooksDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: SearchBooks.SearchBook.Response) {
        let isbn = response.book.isbn13
        print(isbn)
        
//        let viewModel = SearchBooks.SearchBook.ViewModel()
//        viewController?.displaySomething(viewModel: viewModel)
    }
}
