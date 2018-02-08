import UIKit

final class MenuViewController: UIViewController {
    @IBOutlet weak var openOverCurrent: UIButton!
    @IBOutlet weak var openFullScreen: UIButton!
    @IBOutlet weak var closeButton: UIButton!

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.gray
        openOverCurrent.setTitleColor(UIColor.lightGray, for: .normal)
        openFullScreen.setTitleColor(UIColor.lightGray, for: .normal)
        closeButton.setTitleColor(UIColor.lightGray, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.addTarget(self, action: #selector(touchedClose(_:)), for: .touchUpInside)
    }

    @objc func touchedClose(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
