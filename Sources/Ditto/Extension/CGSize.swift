import SwiftUI

@available(iOS 16, macOS 13, watchOS 9, *)
extension CGSize {
    public static let device = Room.device
    public static let statusbar = Room.statusbar
    public static let homebar = Room.homebar
    public static let container = Room.container
}

@available(iOS 16, macOS 13, watchOS 9, *)
extension CGSize {
    /*** create new CGSize with input ratio */
    public func x(_ ratio: CGFloat) -> CGSize {
        return CGSize(width: self.width*ratio, height: self.height*ratio)
    }
    
    /*** create new CGSize with input ratio */
    public func x(w ratioWidth: CGFloat, h ratioHeight: CGFloat) -> CGSize {
        return CGSize(width: self.width*ratioWidth, height: self.height*ratioHeight)
    }
    
    /*** create new CGSize with add input size */
    public func add(_ size: CGSize) -> CGSize {
        return CGSize(width: self.width + size.width, height: self.height + size.height)
    }
    
    /*** create new CGSize with add input size */
    public func add(w width: CGFloat, h height: CGFloat) -> CGSize {
        return CGSize(width: self.width + width, height: self.height + height)
    }
    
    /*** create new CGSize with subtract input size */
    public func sub(_ size: CGSize) -> CGSize {
        return CGSize(width: self.width - size.width, height: self.height - size.height)
    }
}
