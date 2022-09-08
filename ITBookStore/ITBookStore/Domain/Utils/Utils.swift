import UIKit

func mainThread(block: @escaping () -> Void) {
    DispatchQueue.main.async {
        block()
    }
}

func backgroundThread(block: @escaping () -> Void) {
    DispatchQueue.global().async {
        block()
    }
}

func createSpinnerFooter(view: UIView) -> UIView {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
    let spinner = UIActivityIndicatorView()
    spinner.center = footerView.center
    footerView.addSubview(spinner)
    spinner.startAnimating()
    return footerView
}
