import UIKit

public protocol Presenter {
    var isEnabled: Bool { get set }

    func present(completion: (() -> Void)?)
    func present()
}

extension Presenter {
    public func present() {
        present(completion: nil)
    }
}
