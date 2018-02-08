import UIKit

import Box

final class NonInteractivePresentationController<Configuration: NonInteractiveConfiguration>: UIPresentationController, UIViewControllerTransitioningDelegate {
    private let configuration: Configuration
    private let overlay = OverlayView()
    private let scene: Variable<Scene?> = Variable(nil)
    private let autoresizingMaskTranslation: Variable<Bool> = Variable(true)

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, configuration: Configuration) {
        self.configuration = configuration
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationTransitioning(
            overlay: overlay,
            scene: scene,
            autoresizingMaskTranslation: autoresizingMaskTranslation,
            animation: configuration.animation
        )
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissalTransitioning(
            overlay: overlay,
            scene: scene,
            autoresizingMaskTranslation: autoresizingMaskTranslation,
            animation: configuration.animation
        )
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
}

final class InteractivePresentationController<Configuration: InteractiveConfiguration>: UIPresentationController, UIViewControllerTransitioningDelegate {
    private let configuration: Configuration
    private let overlay = OverlayView()
    private let scene: Variable<Scene?> = Variable(nil)
    private let autoresizingMaskTranslation: Variable<Bool> = Variable(true)

    let interactiveTransitioning: Variable<UIPercentDrivenInteractiveTransition?> = Variable(nil)

    private var dismisser: Dismisser<Configuration>?

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, configuration: Configuration) {
        self.configuration = configuration
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationTransitioning(
            overlay: overlay,
            scene: scene,
            autoresizingMaskTranslation: autoresizingMaskTranslation,
            animation: configuration.animation
        )
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissalTransitioning(
            overlay: overlay,
            scene: scene,
            autoresizingMaskTranslation: autoresizingMaskTranslation,
            animation: configuration.animation
        )
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning.value
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning.value
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        interactiveTransitioning.value = nil
        if completed {
            dismisser = Dismisser(configuration, for: presentedViewController, with: overlay, interactiveTransitioning: interactiveTransitioning)
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        interactiveTransitioning.value = nil
        if completed {
            dismisser = nil
        }
    }
}
