public protocol Animation {
    var duration: Double { get }
    var options: UIViewAnimationOptions { get }

    func firstScene(for stage: Stage) -> Scene
    func lastScene(for stage: Stage) -> Scene
}

extension Animation {
    public var options: UIViewAnimationOptions { return [] }
}
