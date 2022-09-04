import Foundation
import UIKit

enum Tabs {
    case search
    case favorites

    private var index: Int {
        switch self {
        case .search:
            return 0
        case .favorites:
            return 1
        }
    }

    var item: UITabBarItem {
        switch self {
        case .search:
            return UITabBarItem(tabBarSystemItem: .search, tag: index)
        case .favorites:
            return UITabBarItem(tabBarSystemItem: .favorites, tag: index)
        }
    }
}

final class MainTabBarController: UITabBarController {
    
    required init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
