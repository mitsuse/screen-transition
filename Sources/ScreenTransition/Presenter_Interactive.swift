import UIKit

import Box

public final class InteractivePresenter<Configuration: InteractiveConfiguration>: NSObject, Presenter, Configurable {
    public let configuration: Configuration
    public let presenting: Weak<UIViewController>
    public let create: () -> UIViewController
    public let presentationGestureRecognizer: Configuration.PresentationGestureRecognizer

    public var isEnabled: Bool = true

    private var interactiveTransitioning: UIPercentDrivenInteractiveTransition?

    init(_ configuration: Configuration, from presenting: UIViewController, to presented: @escaping @autoclosure () -> UIViewController) {
        self.configuration = configuration
        self.presenting = Weak(presenting)
        self.create = presented
        self.presentationGestureRecognizer = configuration.presentationGestureRecognizer
        super.init()

        presenting.view.addGestureRecognizer(presentationGestureRecognizer)
        presentationGestureRecognizer.addTarget(self, action: #selector(handlePresentationGesture(_:)))
    }

    public func present(completion: (() -> Void)?) {
        guard isEnabled else { return }
        presenting.value?.screenTransition.present(create(), with: configuration, completion: completion)
    }

    @objc func handlePresentationGesture(_ gestureRecognizer: UIGestureRecognizer) {
        guard isEnabled else { return }
        switch gestureRecognizer {
        case let gestureRecognizer as Configuration.PresentationGestureRecognizer: handleGenericGesture(gestureRecognizer)
        default: break
        }
    }

    private func handleGenericGesture<GestureRecognizer: UIGestureRecognizer>(_ gestureRecognizer: GestureRecognizer) where GestureRecognizer: Progressive {
        gestureRecognizer is UITapGestureRecognizer ? handleTapGesture(gestureRecognizer) : handleOtherGesture(gestureRecognizer)
    }

    private func handleTapGesture<GestureRecognizer: UIGestureRecognizer>(_ gestureRecognizer: GestureRecognizer) where GestureRecognizer: Progressive {
        guard interactiveTransitioning == nil else { return };
        switch gestureRecognizer.state {
        case .ended: presenting.value?.screenTransition.present(create(), with: configuration, completion: nil)
        case .began, .cancelled, .changed, .failed, .possible: break
        @unknown default: fatalError()
        }
    }

    private func handleOtherGesture<GestureRecognizer: UIGestureRecognizer>(_ gestureRecognizer: GestureRecognizer) where GestureRecognizer: Progressive {
        switch gestureRecognizer.state {
        case .began:
            guard interactiveTransitioning == nil else { return };
            interactiveTransitioning = UIPercentDrivenInteractiveTransition()
            presenting.value?.screenTransition.present(create(), with: configuration, interactivelly: interactiveTransitioning, completion: nil)
        case .changed:
            interactiveTransitioning?.update(gestureRecognizer.progress)
        case .cancelled, .ended, .failed:
            if gestureRecognizer.shouldBeFinished && gestureRecognizer.state == .ended {
                interactiveTransitioning?.finish()
            } else {
                interactiveTransitioning?.cancel()
            }
            interactiveTransitioning = nil
        case .possible:
            break
        @unknown default:
            fatalError()
        }
    }
}
