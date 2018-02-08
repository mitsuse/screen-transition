import UIKit

public struct Layout {
    public let centerX: NSLayoutXAxisAnchor
    public let centerY: NSLayoutYAxisAnchor
    public let top: NSLayoutYAxisAnchor
    public let bottom: NSLayoutYAxisAnchor
    public let left: NSLayoutXAxisAnchor
    public let right: NSLayoutXAxisAnchor
    public let height: NSLayoutDimension
    public let width: NSLayoutDimension

    init(_ view: UIView) {
        self.centerX = view.centerXAnchor
        self.centerY = view.centerYAnchor
        self.top = view.topAnchor
        self.bottom = view.bottomAnchor
        self.left = view.leftAnchor
        self.right = view.rightAnchor
        self.height = view.heightAnchor
        self.width = view.widthAnchor
    }
}
