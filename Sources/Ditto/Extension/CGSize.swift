import SwiftUI

@available(iOS 16, macOS 13, watchOS 9, *)
extension CGSize {
    /*** create new CGSize with input ratio */
    public func x(_ ratio: CGFloat) -> CGSize {
        return CGSize(width: self.width*ratio, height: self.height*ratio)
    }
    
    /*** create new CGSize with input ratio */
    public func x(w ratioW: CGFloat, h ratioH: CGFloat) -> CGSize {
        return CGSize(width: self.width*ratioW, height: self.height*ratioH)
    }
}
