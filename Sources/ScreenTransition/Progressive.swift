public protocol Progressive {
    var shouldBeFinished: Bool { get }
    var progress: CGFloat { get }
}
