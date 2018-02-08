import UIKit

public struct Scene {
    public let constraints: Set<NSLayoutConstraint>
    public let overlay: Overlay
    public let sourceTransform: CGAffineTransform
    public let destinationTransform: CGAffineTransform

    public init(
        constraints: Set<NSLayoutConstraint>,
        overlay: Overlay,
        sourceTransform: CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 1.0),
        destinationTransform: CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    ) {
        self.constraints = constraints
        self.overlay = overlay
        self.sourceTransform = sourceTransform
        self.destinationTransform = destinationTransform
    }
}

func apply(_ scene: Scene, to context: Context, andClean requireCleaning: Bool = false) {
    context.overlay.update(scene.overlay)
    scene.constraints.forEach { $0.isActive = true }
    context.source.view.transform = scene.sourceTransform
    context.layoutContainer.typedView.clippingView.transform = scene.destinationTransform
    context.superView.layoutIfNeeded()
    if requireCleaning { unapply(scene) }
}

func unapply(_ scene: Scene) {
    scene.constraints.forEach { $0.isActive = false }
}
