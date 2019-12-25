import UIKit

extension UITapGestureRecognizer: Progressive {
    public var shouldBeFinished: Bool { return true }
    public var progress: CGFloat { return 1.0 }
}

public final class PanGestureRecognizer: UIPanGestureRecognizer, Progressive {
    private let axis: Axis
    private let direction: Direction
    private let detectEdge: Bool

    private var start: CGPoint?
    private var current: CGPoint?

    public var shouldBeFinished: Bool {
        let l = component(of: location(in: view?.window), on: axis)
        let s = component(of: view?.window?.bounds.size, on: axis)
        let v = component(of: velocity(in: view?.window), on: axis)
        let edgeThreshold: CGFloat = 20
        let onEdge = detectEdge && (direction == .positive ? edgeThreshold + l > s : l < edgeThreshold)
        return s <= 0 || onEdge || (v > 0) == (direction == .positive) && (progress > 0.3 || (progress > 0.0 && abs(v) / s > 2.5))
    }

    public var movement: CGPoint? {
        guard let start = self.start, let current = self.current else { return nil }
        return CGPoint(x: current.x - start.x, y: current.y - start.y)
    }

    public var progress: CGFloat {
        let m = component(of: movement, on: axis)
        let s = component(of: view?.window?.bounds.size, on: axis)
        guard s > 0 else { return 0.0 }
        return min(max(0, CGFloat(direction.rawValue) * m) / s, 1.0)
    }

    public init(target: Any?, action: Selector?, axis: Axis, direction: Direction, detectEdge: Bool, delegate: UIGestureRecognizerDelegate?) {
        self.axis = axis
        self.direction = direction
        self.detectEdge = detectEdge
        super.init(target: target, action: action)
        self.delegate = delegate
        self.addTarget(self, action: #selector(panned))
    }

    public convenience init(axis: Axis, direction: Direction, detectEdge: Bool = false, delegate: UIGestureRecognizerDelegate? = nil) {
        self.init(target: nil, action: nil, axis: axis, direction: direction, detectEdge: detectEdge, delegate: delegate)
    }

    @objc func panned() {
        switch self.state {
        case .began:
            let point = self.location(in: self.view?.window)
            self.start = point
            self.current = point
        case .cancelled, .changed, .ended, .failed:
            self.current = self.location(in: self.view?.window)
        case .possible:
            break
        @unknown default:
            fatalError()
        }
    }

    public enum Axis: Int {
        case horizontal
        case vertical
    }

    public enum Direction: Int {
        case negative = -1
        case positive = 1
    }
}

private func component(of bounds: CGSize?, on axis: PanGestureRecognizer.Axis) -> CGFloat {
    switch axis {
    case .horizontal: return bounds?.width ?? 0
    case .vertical: return bounds?.height ?? 0
    }
}

private func component(of point: CGPoint?, on axis: PanGestureRecognizer.Axis) -> CGFloat {
    switch axis {
    case .horizontal: return point?.x ?? 0
    case .vertical: return point?.y ?? 0
    }
}
