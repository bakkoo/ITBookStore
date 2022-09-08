import UIKit

protocol BookDetailsPresentationLogic
{
  func presentSomething(response: BookDetails.BookDetail.Response)
}

class BookDetailsPresenter: BookDetailsPresentationLogic
{
  weak var viewController: BookDetailsDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: BookDetails.BookDetail.Response)
  {
//    let viewModel = BookDetails.BookDetail.ViewModel()
//    viewController?.displaySomething(viewModel: viewModel)
  }
}
