import CoreGraphics
import SwiftUI

extension View {
    @MainActor
    public func mosaic(_ sampling: CGFloat = 5) -> some View {
        let zero = Image(systemName: "")
        
        let renderer = ImageRenderer(content: self)
        guard let image = renderer.uiImage else {
            print("render ui image from image error")
            return zero
        }
        
        guard let currentCGImage = image.cgImage else {
            print("get cg image from ui image error")
            return zero
        }
        
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIPixellate")
        filter?.setValue(currentCIImage, forKey: kCIInputImageKey)
        filter?.setValue(sampling, forKey: kCIInputScaleKey)
        guard let outputImage = filter?.outputImage else {
            print("output image from filter error")
            return zero
        }

        let context = CIContext()

        guard let cg = context.createCGImage(outputImage, from: outputImage.extent) else {
            print("create cg image from output image error")
            return zero
        }
        
        return Image(uiImage: UIImage(cgImage: cg))
    }
}

#if DEBUG
#Preview {
    return VStack {
        Image(systemName: "pin.fill")
            .mosaic()
        Image(systemName: "plus")
            .mosaic()
        Image(systemName: "multiply")
            .mosaic(5)
    }
}
#endif

