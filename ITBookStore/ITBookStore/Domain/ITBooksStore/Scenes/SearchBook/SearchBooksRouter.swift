import UIKit

@objc protocol SearchBooksRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol SearchBooksDataPassing {
    var dataStore: SearchBooksDataStore? { get }
}

class SearchBooksRouter: NSObject, SearchBooksRoutingLogic, SearchBooksDataPassing {
    weak var viewController: SearchBooksViewController?
    var dataStore: SearchBooksDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: SearchBooksViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: SearchBooksDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
