import UIKit

import Box

final class Dismisser<Configuration: InteractiveConfiguration>: NSObject {
    private let dismissalGestureRecognizer: Configuration.DismissalGestureRecognizer
    private let dismissalOverlayGestureRecognizer: Configuration.DismissalOverlayGestureRecognizer
    private let interactiveTransitioning: Variable<UIPercentDrivenInteractiveTransition?>
    private let presented: Weak<UIViewController>

    init(_ configuration: Configuration, for viewController: UIViewController, with overlay: OverlayView, interactiveTransitioning: Variable<UIPercentDrivenInteractiveTransition?>) {
        self.dismissalGestureRecognizer = configuration.dismissalGestureRecognizer
        self.dismissalOverlayGestureRecognizer = configuration.dismissalOverlayGestureRecognizer
        self.interactiveTransitioning = interactiveTransitioning
        self.presented = Weak(viewController)
        super.init()

        viewController.view.addGestureRecognizer(dismissalGestureRecognizer)
        overlay.addGestureRecognizer(dismissalOverlayGestureRecognizer)
        dismissalGestureRecognizer.addTarget(self, action: #selector(handleDismissalGesture(_:)))
        dismissalOverlayGestureRecognizer.addTarget(self, action: #selector(handleDismissalGesture(_:)))
    }

    @objc func handleDismissalGesture(_ gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer {
        case let gestureRecognizer as Configuration.DismissalGestureRecognizer: handleGenericGesture(gestureRecognizer)
        case let gestureRecognizer as Configuration.DismissalOverlayGestureRecognizer: handleGenericGesture(gestureRecognizer)
        default: break
        }
    }

    private func handleGenericGesture<GestureRecognizer: UIGestureRecognizer>(_ gestureRecognizer: GestureRecognizer) where GestureRecognizer: Progressive {
        gestureRecognizer is UITapGestureRecognizer ? handleTapGesture(gestureRecognizer) : handleOtherGesture(gestureRecognizer)
    }

    private func handleTapGesture<GestureRecognizer: UIGestureRecognizer>(_ gestureRecognizer: GestureRecognizer) where GestureRecognizer: Progressive {
        guard interactiveTransitioning.value == nil else { return };
        switch gestureRecognizer.state {
        case .ended: presented.value?.dismiss(animated: true, completion: nil)
        case .began, .cancelled, .changed, .failed, .possible: break
        @unknown default: fatalError()
        }
    }

    private func handleOtherGesture<GestureRecognizer: UIGestureRecognizer>(_ gestureRecognizer: GestureRecognizer) where GestureRecognizer: Progressive {
        switch gestureRecognizer.state {
        case .began:
            guard interactiveTransitioning.value == nil else { break };
            interactiveTransitioning.value = UIPercentDrivenInteractiveTransition()
            presented.value?.dismiss(animated: true, completion: nil)
        case .changed:
            interactiveTransitioning.value?.update(gestureRecognizer.progress)
        case .cancelled, .ended, .failed:
            if gestureRecognizer.shouldBeFinished && gestureRecognizer.state == .ended {
                interactiveTransitioning.value?.finish()
            } else {
                interactiveTransitioning.value?.cancel()
            }
            interactiveTransitioning.value = nil
        case .possible:
            break
        @unknown default:
            fatalError()
        }
    }
}
