import SwiftUI

extension CGSize {
    static public let statusbar: CGSize = Device.statusbarArea
    static public let homebar: CGSize = Device.homebarArea
    static public let safeArea: CGSize = Device.safeArea
    static public let unsafeArea: CGSize = Device.screen
    static public let screen: CGSize = Device.unsafeArea
}

extension CGSize {
    /*** create new CGSize with input ratio */
    public func x(_ ratio: CGFloat) -> CGSize {
        return CGSize(width: self.width*ratio, height: self.height*ratio)
    }
    
    /*** create new CGSize with input ratio */
    public func x(w ratioWidth: CGFloat = 1, h ratioHeight: CGFloat = 1) -> CGSize {
        return CGSize(width: self.width*ratioWidth, height: self.height*ratioHeight)
    }
    
    /*** create new CGSize with add input size */
    public func add(_ size: CGSize) -> CGSize {
        return CGSize(width: self.width + size.width, height: self.height + size.height)
    }
    
    /*** create new CGSize with add input size */
    public func add(w width: CGFloat = 0, h height: CGFloat = 0) -> CGSize {
        return CGSize(width: self.width + width, height: self.height + height)
    }
    
    /*** create new CGSize with subtract input size */
    public func sub(_ size: CGSize) -> CGSize {
        return CGSize(width: self.width - size.width, height: self.height - size.height)
    }
    
    /*** create new CGSize with subtract input size */
    public func sub(w width: CGFloat = 0, h height: CGFloat = 0) -> CGSize {
        return CGSize(width: self.width - width, height: self.height - height)
    }
    
    /*** create new CGSize with replacement */
    public func replace(w width: CGFloat? = nil, h height: CGFloat? = nil) -> CGSize {
        return CGSize(width: width ?? self.width, height: height ?? self.height)
    }
}
