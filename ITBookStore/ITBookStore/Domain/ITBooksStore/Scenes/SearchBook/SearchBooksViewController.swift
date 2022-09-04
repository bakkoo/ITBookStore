import UIKit

protocol SearchBooksDisplayLogic: AnyObject {
    func displaySomething(viewModel: SearchBooks.Something.ViewModel)
}

class SearchBooksViewController: UIViewController, SearchBooksDisplayLogic {
    var interactor: SearchBooksBusinessLogic?
    var router: (NSObjectProtocol & SearchBooksRoutingLogic & SearchBooksDataPassing)?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: UITableViewCell().reuseIdentifier!, bundle: nil), forCellReuseIdentifier: UITableViewCell().reuseIdentifier!)
        return tableView
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
        self.view.backgroundColor = .red
        doSomething()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething() {
        let request = SearchBooks.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: SearchBooks.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}
