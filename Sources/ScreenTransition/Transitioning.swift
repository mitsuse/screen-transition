import UIKit

import Box

final class PresentationTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    private let overlay: OverlayView
    private let scene: Variable<Scene?>
    private let autoresizingMaskTranslation: Variable<Bool>
    private let animation: Animation

    init(overlay: OverlayView, scene: Variable<Scene?>, autoresizingMaskTranslation: Variable<Bool>, animation: Animation) {
        self.overlay = overlay
        self.scene = scene
        self.autoresizingMaskTranslation = autoresizingMaskTranslation
        self.animation = animation
        super.init()
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let context = PresentationContext(transitionContext, with: overlay)
        let stage = Stage(context)
        let options = animation.options
        let firstScene = animation.firstScene(for: stage)
        let lastScene = animation.lastScene(for: stage)

        autoresizingMaskTranslation.value = context.source.view.translatesAutoresizingMaskIntoConstraints
        context.prepare()
        apply(firstScene, to: context, andClean: true)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: options,
            animations: { apply(lastScene, to: context) },
            completion: { [transitionContext, autoresizingMaskTranslation, scene] completed in
                let transitionCompleted = completed && !transitionContext.transitionWasCancelled
                if transitionCompleted {
                    scene.value = lastScene
                } else {
                    unapply(lastScene)
                    context.source.view.translatesAutoresizingMaskIntoConstraints = autoresizingMaskTranslation.value
                    context.cancel()
                }
                transitionContext.completeTransition(transitionCompleted)
            }
        )
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animation.duration
    }
}

final class DismissalTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    private let overlay: OverlayView
    private let scene: Variable<Scene?>
    private let autoresizingMaskTranslation: Variable<Bool>
    private let animation: Animation

    init(overlay: OverlayView, scene: Variable<Scene?>, autoresizingMaskTranslation: Variable<Bool>, animation: Animation) {
        self.overlay = overlay
        self.scene = scene
        self.autoresizingMaskTranslation = autoresizingMaskTranslation
        self.animation = animation
        super.init()
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let context = DismissalContext(transitionContext, with: overlay)
        let stage = Stage(context)
        let options = animation.options
        let firstScene = animation.firstScene(for: stage)

        if let scene = scene.value { apply(scene, to: context, andClean: true) }

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: options,
            animations: { apply(firstScene, to: context) },
            completion: { [transitionContext, autoresizingMaskTranslation, scene] completed in
                let transitionCompleted = completed && !transitionContext.transitionWasCancelled
                unapply(firstScene)
                if transitionCompleted {
                    context.source.view.translatesAutoresizingMaskIntoConstraints = autoresizingMaskTranslation.value
                    context.complete()
                } else {
                    if let scene = scene.value { apply(scene, to: context) }
                }
                transitionContext.completeTransition(transitionCompleted)
            }
        )
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animation.duration
    }
}
