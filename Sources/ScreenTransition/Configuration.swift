import UIKit

public protocol Configuration {
    var animation: Animation { get }
}

public protocol Configurable {
    associatedtype Configuration: ScreenTransition.Configuration

    var configuration: Configuration { get }
}

public protocol InteractiveConfiguration: Configuration {
    associatedtype PresentationGestureRecognizer: UIGestureRecognizer, Progressive
    associatedtype DismissalGestureRecognizer: UIGestureRecognizer, Progressive
    associatedtype DismissalOverlayGestureRecognizer: UIGestureRecognizer, Progressive

    var presentationGestureRecognizer: PresentationGestureRecognizer { get }
    var dismissalGestureRecognizer: DismissalGestureRecognizer { get }
    var dismissalOverlayGestureRecognizer: DismissalOverlayGestureRecognizer { get }
}

public protocol NonInteractiveConfiguration: Configuration {
    associatedtype PresentationGestureRecognizer = Void
    associatedtype DismissalGestureRecognizer = Void
    associatedtype DismissalOverlayGestureRecognizer = Void
}
