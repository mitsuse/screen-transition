import UIKit

protocol Context {
    var layoutContainer: LayoutContainerViewController { get }
    var transitionContainer: UIView { get }
    var superView: UIView { get }
    var source: UIViewController { get }
    var destination: UIViewController { get }
    var overlay: OverlayView { get }
}

struct PresentationContext: Context {
    let layoutContainer: LayoutContainerViewController
    let transitionContainer: UIView
    let superView: UIView
    let source: UIViewController
    let destination: UIViewController
    let overlay: OverlayView
}

extension PresentationContext {
    init(_ transitionContext: UIViewControllerContextTransitioning, with overlay: OverlayView) {
        let layoutContainer = transitionContext.viewController(forKey: .to)  as! LayoutContainerViewController
        let transitionContainer = transitionContext.containerView
        self.init(
            layoutContainer: layoutContainer,
            transitionContainer: transitionContainer,
            superView: transitionContainer.superview!,
            source: transitionContext.viewController(forKey: .from)!,
            destination: layoutContainer.content,
            overlay: overlay
        )
    }

    func prepare() {
        source.view.translatesAutoresizingMaskIntoConstraints = false
        destination.view.translatesAutoresizingMaskIntoConstraints = false
        source.view.addSubview(overlay)
        transitionContainer.addSubview(layoutContainer.view)
    }

    func cancel() {
        overlay.removeFromSuperview()
    }
}

struct DismissalContext: Context {
    let layoutContainer: LayoutContainerViewController
    let transitionContainer: UIView
    let superView: UIView
    let source: UIViewController
    let destination: UIViewController
    let overlay: OverlayView
}

extension DismissalContext {
    init(_ transitionContext: UIViewControllerContextTransitioning, with overlay: OverlayView) {
        let layoutContainer = transitionContext.viewController(forKey: .from)  as! LayoutContainerViewController
        let transitionContainer = transitionContext.containerView
        self.init(
            layoutContainer: layoutContainer,
            transitionContainer: transitionContainer,
            superView: transitionContainer.superview!,
            source: transitionContext.viewController(forKey: .to)!,
            destination: layoutContainer.content,
            overlay: overlay
        )
    }

    func complete() {
        overlay.removeFromSuperview()
    }
}
