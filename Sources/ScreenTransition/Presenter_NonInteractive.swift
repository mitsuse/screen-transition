import UIKit

import Box

public final class NonInteractivePresenter<Configuration: NonInteractiveConfiguration>: NSObject, Presenter, Configurable {
    public let configuration: Configuration
    public let presenting: Weak<UIViewController>
    public let create: () -> UIViewController

    public var isEnabled: Bool = true

    init(_ configuration: Configuration, from presenting: UIViewController, to presented: @escaping @autoclosure () -> UIViewController) {
        self.configuration = configuration
        self.presenting = Weak(presenting)
        self.create = presented
        super.init()
    }

    public func present(completion: (() -> Void)?) {
        guard isEnabled else { return }
        presenting.value?.screenTransition.present(create(), with: configuration, completion: completion)
    }
}

