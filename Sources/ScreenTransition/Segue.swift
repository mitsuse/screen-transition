import UIKit

open class Segue: UIStoryboardSegue {
    private let configuration: SegueConfiguration

    public init(identifier: String?, source: UIViewController, destination: UIViewController, configuration: Configuration) {
        self.configuration = SegueConfiguration(configuration)
        super.init(identifier: identifier, source: source, destination: destination)
    }

    open override func perform() {
        source.screenTransition.present(destination, with: configuration, completion: nil)
    }
}

private final class SegueConfiguration: NonInteractiveConfiguration {
    let animation: Animation

    init(_ configuration: Configuration) {
        self.animation = configuration.animation
    }
}
