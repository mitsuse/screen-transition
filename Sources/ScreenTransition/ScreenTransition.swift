public protocol Extended {
    associatedtype Base

    var screenTransition: Extension<Base> { get }
}

public struct Extension<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}
