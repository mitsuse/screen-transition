import UIKit

import ScreenTransition

final class LeftDrawerSegue: Segue {
    @objc init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(
            identifier: identifier,
            source: source,
            destination: destination,
            configuration: DrawerConfiguration(position: .left, offset: 60)
        )
    }
}

final class RightDrawerSegue: Segue {
    @objc init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(
            identifier: identifier,
            source: source,
            destination: destination,
            configuration: DrawerConfiguration(position: .right, offset: 60)
        )
    }
}

final class DrawerConfiguration: NonInteractiveConfiguration {
    private let position: DrawerPosition
    private let offset: CGFloat

    var animation: Animation {
        return DrawerAnimation(position: position, offset: offset)
    }

    init(position: DrawerPosition, offset: CGFloat) {
        self.position = position
        self.offset = offset
    }
}

final class DrawerAnimation: Animation {
    private let position: DrawerPosition
    private let offset: CGFloat

    let duration: Double = 0.6
    let options: UIViewAnimationOptions = .curveEaseOut

    init(position: DrawerPosition, offset: CGFloat) {
        self.position = position
        self.offset = offset
    }

    func firstScene(for stage: Stage) -> Scene {
        return Scene(
            constraints: [
                stage.source.centerX.constraint(equalTo: stage.parent.centerX),
                stage.source.centerY.constraint(equalTo: stage.parent.centerY),
                stage.source.width.constraint(equalTo: stage.parent.width),
                stage.source.height.constraint(equalTo: stage.parent.height),
                position == .left
                    ? stage.clipping.left.constraint(equalTo: stage.container.left)
                    : stage.clipping.left.constraint(equalTo: stage.container.right),
                stage.clipping.centerY.constraint(equalTo: stage.container.centerY),
                stage.clipping.height.constraint(equalTo: stage.container.height),
                stage.clipping.width.constraint(equalToConstant: 0),
                stage.destination.centerX.constraint(equalTo: stage.container.centerX, constant: position == .left ? -offset : offset),
                stage.destination.centerY.constraint(equalTo: stage.container.centerY),
                stage.destination.width.constraint(equalTo: stage.container.width),
                stage.destination.height.constraint(equalTo: stage.container.height),
            ],
            overlay: Overlay(color: UIColor.white, alpha: 0.0)
        )
    }

    func lastScene(for stage: Stage) -> Scene {
        return Scene(
            constraints: [
                position == .left
                    ? stage.source.left.constraint(equalTo: stage.parent.right, constant: -offset)
                    : stage.source.right.constraint(equalTo: stage.parent.left, constant: offset),
                stage.source.centerY.constraint(equalTo: stage.parent.centerY),
                stage.source.width.constraint(equalTo: stage.parent.width),
                stage.source.height.constraint(equalTo: stage.parent.height),
                stage.clipping.left.constraint(equalTo: stage.container.left, constant: position == .left ? 0 : offset),
                stage.clipping.right.constraint(equalTo: stage.container.right, constant: position == .right ? 0 : -offset),
                stage.clipping.centerY.constraint(equalTo: stage.container.centerY),
                stage.clipping.height.constraint(equalTo: stage.container.height),
                stage.destination.centerX.constraint(equalTo: stage.container.centerX),
                stage.destination.centerY.constraint(equalTo: stage.container.centerY),
                stage.destination.width.constraint(equalTo: stage.container.width),
                stage.destination.height.constraint(equalTo: stage.container.height),
            ],
            overlay: Overlay(color: UIColor.white, alpha: 0.6)
        )
    }
}

enum DrawerPosition: Int {
    case left
    case right
}
