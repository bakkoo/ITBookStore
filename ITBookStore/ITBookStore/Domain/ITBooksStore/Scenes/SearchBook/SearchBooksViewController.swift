import UIKit
import Combine

protocol SearchBooksDisplayLogic: AnyObject {
    func displaySomething(viewModel: SearchBooks.SearchBook.ViewModel)
}

class SearchBooksViewController: UIViewController, SearchBooksDisplayLogic {
    
    var interactor: (SearchBooksBusinessLogic & SearchBooksInteractor)?
    
    var router: (NSObjectProtocol & SearchBooksRoutingLogic & SearchBooksDataPassing)?
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var subscribers = Set<AnyCancellable>()
    private var books: [Book] = []
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(BookCell.self, forCellReuseIdentifier: BookCell.identifier)
        table.layer.backgroundColor = UIColor.white.cgColor
        table.tableFooterView = UIView(frame: .zero)
        return table
    }()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = SearchBooksInteractor()
        let presenter = SearchBooksPresenter()
        let router = SearchBooksRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Books"
        tableView.delegate = self
        tableView.dataSource = self
        setupTableViewConstraints()
        configureSearchController()
        setupObservables()
        listenForSearchTextChanges()
    }
    
    private func configureSearchController() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    fileprivate func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: Observable
    func setupObservables() {
        interactor?.onReload = {[weak self] in
            mainThread {
                self?.tableView.reloadData()
                self?.tableView.tableFooterView = nil
            }
        }
        interactor?.$isFinished.sink(receiveValue: { isFinished in
            mainThread {
                self.tableView.reloadData()
                self.tableView.tableFooterView = nil
            }
        }).store(in: &subscribers)
        
    }
    private func listenForSearchTextChanges() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        publisher
            .map { ($0.object as! UISearchTextField).text }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { str in
                self.interactor?.reset()
                guard let text = str?.lowercased().removeWhitespace(), str != "" else { return }
                let request = SearchBooks.SearchBook.Request(searchText: text, isPaginating: false, reload: false)
                self.interactor?.searchBooks(request: request)
            }.store(in: &subscribers)
    }
    
    func displaySomething(viewModel: SearchBooks.SearchBook.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

// MARK: Table View Delegate
extension SearchBooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: Table View Datasource
extension SearchBooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interactor?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier, for: indexPath) as? BookCell else { return UITableViewCell() }
        if let viewModel = interactor?.itemForRow(at: indexPath) {
            cell.configure(with: viewModel.image, title: viewModel.title)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.didSelectRow(at: indexPath)
    }
    
}

// MARK: Search Delegate
extension SearchBooksViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        interactor?.isReachedMaxPageIndex = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty {
            interactor?.reset()
        }
    }
}
// MARK: ScrollView Delegate
extension SearchBooksViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard tableView.contentOffset.y > tableView.contentSize.height - tableView.frame.size.height else { return }
        guard let isPaginationAllowed = interactor?.isPaginationAllowed() else { return }
        
        guard isPaginationAllowed else { return }

        if let text = searchController.searchBar.text?.removeWhitespace().lowercased() {
            if !text.isEmpty {
                interactor?.paginationStarted?()
                self.tableView.tableFooterView = createSpinnerFooter(view: view)
                interactor?.isPaginationInProgress = true
                let request = SearchBooks.SearchBook.Request(searchText: text, isPaginating: true, reload: false)
                interactor?.searchBooks(request: request)
            }
        }
    }
}
