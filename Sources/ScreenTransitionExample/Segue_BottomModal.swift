import UIKit

import ScreenTransition

final class BottomModalSegue: Segue {
    @objc init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination, configuration: BottomModalConfiguration())
    }
}

final class BottomModalConfiguration: InteractiveConfiguration {
    var animation: Animation {
        return BottomModalAnimation()
    }

    var presentationGestureRecognizer: PanGestureRecognizer { return PanGestureRecognizer(axis: .vertical, direction: .negative) }
    var dismissalGestureRecognizer: PanGestureRecognizer { return PanGestureRecognizer(axis: .vertical, direction: .positive, detectEdge: true) }
    var dismissalOverlayGestureRecognizer: UITapGestureRecognizer { return UITapGestureRecognizer() }
}

final class BottomModalAnimation: Animation {
    let duration: Double = 0.8

    func firstScene(for stage: Stage) -> Scene {
        return Scene(
            constraints: [
                stage.source.centerX.constraint(equalTo: stage.parent.centerX),
                stage.source.centerY.constraint(equalTo: stage.parent.centerY),
                stage.source.width.constraint(equalTo: stage.parent.width),
                stage.source.height.constraint(equalTo: stage.parent.height),
                stage.clipping.centerX.constraint(equalTo: stage.container.centerX),
                stage.clipping.top.constraint(equalTo: stage.container.bottom),
                stage.clipping.width.constraint(equalTo: stage.container.width),
                stage.clipping.height.constraint(equalToConstant: 240),
                stage.destination.centerX.constraint(equalTo: stage.clipping.centerX),
                stage.destination.centerY.constraint(equalTo: stage.clipping.centerY),
                stage.destination.width.constraint(equalTo: stage.clipping.width),
                stage.destination.height.constraint(equalTo: stage.clipping.height),
            ],
            overlay: Overlay(color: UIColor.white, alpha: 0.0)
        )
    }

    func lastScene(for stage: Stage) -> Scene {
        return Scene(
            constraints: [
                stage.source.centerX.constraint(equalTo: stage.parent.centerX),
                stage.source.centerY.constraint(equalTo: stage.parent.centerY),
                stage.source.width.constraint(equalTo: stage.parent.width),
                stage.source.height.constraint(equalTo: stage.parent.height),
                stage.clipping.centerX.constraint(equalTo: stage.container.centerX),
                stage.clipping.bottom.constraint(equalTo: stage.container.bottom),
                stage.clipping.width.constraint(equalTo: stage.container.width),
                stage.clipping.height.constraint(equalToConstant: 240),
                stage.destination.centerX.constraint(equalTo: stage.clipping.centerX),
                stage.destination.centerY.constraint(equalTo: stage.clipping.centerY),
                stage.destination.width.constraint(equalTo: stage.clipping.width),
                stage.destination.height.constraint(equalTo: stage.clipping.height),
            ],
            overlay: Overlay(color: UIColor.white, alpha: 0.6)
        )
    }
}
