import UIKit

protocol SearchBooksDisplayLogic: AnyObject {
    func displaySomething(viewModel: SearchBooks.SearchBook.ViewModel)
}

class SearchBooksViewController: UIViewController, SearchBooksDisplayLogic {
    var interactor: SearchBooksBusinessLogic?
    var router: (NSObjectProtocol & SearchBooksRoutingLogic & SearchBooksDataPassing)?
    
    private var dummyData: [String] = {
        let data = [
            "Some data1",
            "Some data2",
            "Some data3",
            "Some data4",
            "Some data5",
            "Some data6",
            "Some data7",
            "Some data8",
            "Some data9"
        ]
        return data
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(BookCell.self, forCellReuseIdentifier: "bookCell")
        table.rowHeight = 100
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
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Books"
        tableView.delegate = self
        tableView.dataSource = self
        doSomething()
        setupTableViewConstraints()
    }
    
    fileprivate func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
        let request = SearchBooks.SearchBook.Request(searchText: "", page: 0)
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: SearchBooks.SearchBook.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

// MARK: Table View Delegate
extension SearchBooksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

// MARK: Table View Datasource
extension SearchBooksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier, for: indexPath) as? BookCell else { return UITableViewCell() }
        cell.configure(with: dummyData[indexPath.row], title: dummyData[indexPath.row])
        return cell
    }
}
