import UIKit

extension UIViewController: Extended {
    public var screenTransition: Extension<UIViewController> { return Extension(self) }
}

extension Extension where Base: UIViewController {
    public func present<Configuration: NonInteractiveConfiguration>(_ viewController: UIViewController, with configuration: Configuration, completion: (() -> Void)?) {
        let layoutContainer = LayoutContainerViewController(viewController)
        let presentationController = NonInteractivePresentationController(presentedViewController: layoutContainer, presenting: base, configuration: configuration)
        layoutContainer.modalPresentationStyle = .custom
        layoutContainer.transitioningDelegate = presentationController
        base.present(layoutContainer, animated: true) { [presentationController] in
            completion?()
            _ = presentationController
        }
    }

    public func present<Configuration: InteractiveConfiguration>(_ viewController: UIViewController, with configuration: Configuration, completion: (() -> Void)?) {
        present(viewController, with: configuration, interactivelly: nil, completion: completion)
    }

    func present<Configuration: InteractiveConfiguration>(
        _ viewController: UIViewController,
        with configuration: Configuration,
        interactivelly interactive: UIPercentDrivenInteractiveTransition?,
        completion: (() -> Void)?
    ) {
        let layoutContainer = LayoutContainerViewController(viewController)
        let presentationController = InteractivePresentationController(presentedViewController: layoutContainer, presenting: base, configuration: configuration)
        presentationController.interactiveTransitioning.value = interactive
        layoutContainer.modalPresentationStyle = .custom
        layoutContainer.transitioningDelegate = presentationController
        base.present(layoutContainer, animated: true) { [presentationController] in
            completion?()
            _ = presentationController
        }
    }
}

extension Extension where Base: UIViewController {
    public func presenter<Configuration: NonInteractiveConfiguration>(
        with configuration: Configuration,
        for viewController: @escaping @autoclosure () -> UIViewController
    ) -> NonInteractivePresenter<Configuration> {
        return NonInteractivePresenter(configuration, from: base, to: viewController())
    }

    public func presenter<Configuration: NonInteractiveConfiguration>(
        with configuration: Configuration,
        for storybaord: UIStoryboard
    ) -> NonInteractivePresenter<Configuration> {
        return presenter(with: configuration, for: storybaord.instantiateInitialViewController()!)
    }
}

extension Extension where Base: UIViewController {
    public func presenter<Configuration: InteractiveConfiguration>(
        with configuration: Configuration,
        for viewController: @escaping @autoclosure () -> UIViewController
    ) -> InteractivePresenter<Configuration> {
        return InteractivePresenter(configuration, from: base, to: viewController())
    }

    public func presenter<Configuration: InteractiveConfiguration>(
        with configuration: Configuration,
        for storybaord: UIStoryboard
    ) -> InteractivePresenter<Configuration> {
        return presenter(with: configuration, for: storybaord.instantiateInitialViewController()!)
    }
}
