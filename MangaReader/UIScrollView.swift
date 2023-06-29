import UIKit

class ViewController: UIViewController {
  
  var scrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the scrollView's frame to be the size of the screen
    scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    scrollView.backgroundColor = .systemTeal
    // Set the contentSize to 100 times the height of the phone's screen so that we can add 100 images in the next step
    scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: UIScreen.main.bounds.height*11)
    view.addSubview(scrollView)
  }
}
