import UIKit

final class ClosableViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.gray
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
