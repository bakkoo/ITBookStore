import UIKit

protocol SearchBooksPresentationLogic {
    func presentSomething(response: SearchBooks.Something.Response)
}

class SearchBooksPresenter: SearchBooksPresentationLogic {
    weak var viewController: SearchBooksDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: SearchBooks.Something.Response) {
        let viewModel = SearchBooks.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
