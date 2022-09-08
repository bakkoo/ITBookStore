import Combine
import UIKit

class SearchBooksWorker: SearchBooksBusinessLogic {

    var isPaginationInProgress: Bool = false
    var isReachedMaxPageIndex: Bool = false
    
    private var subscribers = Set<AnyCancellable>()
    
    var pageNumber = 0
    var onReload: (() -> Void)?
    
    @Published var books: [Book] = []
    var images: [UIImage] = []
    
    func searchBooks(request: SearchBooks.SearchBook.Request, pagination: SearchBooks.SearchBook.Pagination) {
        if pagination.reload { pageNumber = 0 }
        if pagination.isPaginating { pageNumber += 1 }
        
        let endpoint = Endpoint.searchBooks(name: request.searchText, page: pageNumber)
        
        DefaultNetworkController.shared.getData(endpoint: endpoint.url.absoluteString, type: Books.self)
            .sink {[weak self] promise in
                switch promise {
                case .failure(let error):
                    print("🔴 Error at \(String(describing: self)) - \(String(describing: error))")
                case .finished:
                    print("🟢 Data Fetched Succesfully")
                }
            } receiveValue: { data in
                self.booksFetched(books: data.books)
                print(data)
            }.store(in: &self.subscribers)
    }
    
    func fetchImages() {
        images.removeAll()
        books.map({ $0.image })
            .publisher
            .compactMap { URL(string: $0) }
            .flatMap {
                URLSession.shared.dataTaskPublisher(for: $0)
            }
            .compactMap { $0.data }
            .compactMap { UIImage(data: $0) }
            .sink(receiveCompletion: ( {[weak self] _ in
                print("🟢 Images Fetched Succesfully")
                self?.onReload?()
            })) {[weak self] image in
                self?.images.append(image)
                print("////// IMAGE - ",image)
            }
            .store(in: &subscribers)
    }
    
    func booksFetched(books: [Book]?) {
        if let books = books {
            if books.isEmpty {
                isReachedMaxPageIndex = true
                onReload?()
            } else {
                self.books.append(contentsOf: books)
                self.fetchImages()
            }
        }
        isPaginationInProgress = false
    }
    
    
    func didSelectRow(at indexPath: IndexPath) -> Book {
        books[indexPath.row]
    }
    
    func itemForRow(at indexPath: IndexPath) -> SearchBooks.SearchBook.ViewModel {
        guard images.count == books.count else {
            return SearchBooks.SearchBook.ViewModel(image: nil, title: books[indexPath.row].title)
        }
        let viewModel = SearchBooks.SearchBook.ViewModel(image: images[indexPath.row], title: books[indexPath.row].title)
        return viewModel
    }
    
    func numberOfRows() -> Int {
        books.count
    }
    
    func isPaginationAllowed() -> Bool {
        !isPaginationInProgress && !isReachedMaxPageIndex
    }
}
