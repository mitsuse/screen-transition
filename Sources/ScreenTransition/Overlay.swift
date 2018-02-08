import UIKit

public struct Overlay {
    public let color: UIColor
    public let alpha: CGFloat

    public init(color: UIColor, alpha: CGFloat) {
        self.color = color
        self.alpha = alpha
    }
}

final class OverlayView: UIView {
    private var layoutConstraints: Set<NSLayoutConstraint> = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
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

    func update(_ overlay: Overlay) {
        backgroundColor = overlay.color
        alpha = overlay.alpha
    }
}
