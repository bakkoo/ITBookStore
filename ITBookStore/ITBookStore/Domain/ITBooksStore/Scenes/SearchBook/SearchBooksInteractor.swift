import Combine
import Foundation
import UIKit

protocol SearchBooksBusinessLogic {
    func searchBooks(request: SearchBooks.SearchBook.Request)
    
    func didSelectRow(at indexPath: IndexPath)
    func itemForRow(at indexPath: IndexPath) -> SearchBooks.SearchBook.ViewModel
    func numberOfRows() -> Int
    func isPaginationAllowed() -> Bool
}

protocol SearchBooksDataStore {
    var text: String { get set }
}

// TODO: Handle pagination
final class SearchBooksInteractor: SearchBooksBusinessLogic, SearchBooksDataStore {
    var text: String = ""
    
    var presenter: SearchBooksPresentationLogic?
    var searchWorker: (SearchBooksWorker & DefaultSearchBooksWorker)?
    var imageWorker: (ImageWorker & DefaultImageWorker)?
    
    private var subscribers = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?
    @Published var isFinished = false
    @Published var books: [Book] = []
    @Published var images: [UIImage]? = []
    
    var isReachedMaxPageIndex: Bool = false
    var isPaginationInProgress: Bool = false
    
    var paginationStarted: (() -> Void)?
    var onReload: (() -> Void)?
    
    // MARK: - Search books
    func searchBooks(request: SearchBooks.SearchBook.Request) {
        searchWorker?.searchBooks(request: request)
        
        searchWorker?.$books
            .sink(receiveValue: { books in
                print("books count at fetching image closure\(books.count)")
                guard !books.isEmpty else { return }
                self.fetchImages(with: books)
            }).store(in: &subscribers)
        
        guard let publishedImages = imageWorker?.$images else { return }
        searchWorker?.$books.combineLatest(publishedImages)
            .sink(receiveValue: { books, images in
                guard images.count == books.count else { return }
                self.booksFetched(books: books)
                self.images = images
                self.onReload?()
            }).store(in: &subscribers)
    }
    
    init (){
        imageWorker = DefaultImageWorker()
        searchWorker = DefaultSearchBooksWorker()
//        searchWorker?.$books.sink { books in
//            print("BOOKS COUNT -----\(books.count)")
//            self.booksFetched(books: books)
//        }.store(in: &subscribers)
//
//        searchWorker?.$books.sink(receiveCompletion: { _ in
//            print("came complletion")
//        }, receiveValue: { books in
//
//        }).store(in: &subscribers)
//
//        imageWorker?.$images.sink(receiveValue: { images in
//            self.images? = images
//
//        }).store(in: &subscribers)
        
//        group.wait()
//        group.notify(queue: .main) {
//            self.onReload?()
//        }
       
    }
    
    func isPaginationAllowed() -> Bool {
        !isPaginationInProgress && !isReachedMaxPageIndex
    }
    
    func booksFetched(books: [Book]?) {
        print(#function)
        if let books = books {
            if books.isEmpty {
                isReachedMaxPageIndex = true
                onReload?()
            } else {
                print(books.count)
                self.books.append(contentsOf: books)
            }
        }
        isPaginationInProgress = false
    }
    
    func fetchImages(with books: [Book]) {
        imageWorker?.fetchImages(books: books)
    }
    
    func reset() {
        searchWorker?.books.removeAll()
        imageWorker?.images.removeAll()
        searchWorker?.pageNumber = 1
        books.removeAll()
        images?.removeAll()
        isPaginationInProgress = false
        isReachedMaxPageIndex = false
        onReload?()
    }
    
    // MARK: - Table View Methods
    func didSelectRow(at indexPath: IndexPath) {
        let response = SearchBooks.SearchBook.Response(book: books[indexPath.row])
        presenter?.presentSomething(response: response)
    }
    
    func itemForRow(at indexPath: IndexPath) -> SearchBooks.SearchBook.ViewModel {
        print(images?.count,books.count)
        guard images?.count == books.count else {
            return SearchBooks.SearchBook.ViewModel(image: nil, title: books[indexPath.row].title)
        }
        let viewModel = SearchBooks.SearchBook.ViewModel(image: images?[indexPath.row], title: books[indexPath.row].title)
        return viewModel
    }
    
    func numberOfRows() -> Int {
        books.count
    }
}
