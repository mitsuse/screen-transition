public struct Stage {
    public let parent: Layout
    public let container: Layout
    public let source: Layout
    public let destination: Layout
    public let clipping: Layout
}

extension Stage {
    init(_ context: Context) {
        self.init(
            parent: Layout(context.superView),
            container: Layout(context.layoutContainer.view),
            source: Layout(context.source.view),
            destination: Layout(context.destination.view),
            clipping: Layout(context.layoutContainer.typedView.clippingView)
        )
    }
}
