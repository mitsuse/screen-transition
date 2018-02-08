import UIKit

import ScreenContainer

final class LayoutContainerViewController: UIViewController, ScreenContainer.Default {
    var typedView: LayoutContainerView { return view as! LayoutContainerView }

    let content: UIViewController

    init(_ viewController: UIViewController) {
        self.content = viewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = LayoutContainerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        add(content: content, to: typedView.clippingView)
    }
}

final class LayoutContainerView: UIView {
    private let _clippingView = UIScrollView()

    private var layoutConstraints: Set<NSLayoutConstraint> = []

    var clippingView: UIView { return _clippingView }

    override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        _clippingView.translatesAutoresizingMaskIntoConstraints = false
        _clippingView.isScrollEnabled = false
        _clippingView.backgroundColor = UIColor.clear
        addSubview(_clippingView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        layoutConstraints.forEach { $0.isActive = false }
        layoutConstraints = []
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superView = superview else { return }
        layoutConstraints = [
            centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            centerYAnchor.constraint(equalTo: superView.centerYAnchor),
            widthAnchor.constraint(equalTo: superView.widthAnchor),
            heightAnchor.constraint(equalTo: superView.heightAnchor),
        ]
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        layoutConstraints.forEach { $0.isActive = true }
        super.updateConstraints()
    }
}
