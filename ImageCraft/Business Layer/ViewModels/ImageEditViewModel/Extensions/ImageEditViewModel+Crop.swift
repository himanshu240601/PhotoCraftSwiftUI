//
//  ImageEditViewModel+Crop.swift
//  ImageCraft
//
//  Created by Himanshu's MacBook on 03/10/24.
//

import Foundation
import UIKit

extension ImageEditViewModel {
    
    /// method to get crop rect size
    /// - Parameters:
    ///   - imageSize: actual size of image
    ///   - dimension: dimension to crop
    /// - Returns: a CGRect value
    func calculateCropRect(imageSize: CGSize, for dimension: CropDimensions) -> CGRect {
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        
        switch dimension {
        case .free:
            // if free, you can return the full image or let the user define the crop rect
            return CGRect(origin: .zero, size: imageSize)
        
        default:
            // calculate crop dimensions based on aspect ratio
            let aspectRatio = dimension.aspectRatio
            var cropWidth: CGFloat = 0
            var cropHeight: CGFloat = 0
            
            // adjust width and height based on the image and aspect ratio
            if imageWidth / imageHeight > aspectRatio {
                // if the image is wider than the target aspect ratio, fit the height
                cropHeight = imageHeight
                cropWidth = cropHeight * aspectRatio
            } else {
                // if the image is taller than the target aspect ratio, fit the width
                cropWidth = imageWidth
                cropHeight = cropWidth / aspectRatio
            }
            
            // center the crop area within the image
            let x = (imageWidth - cropWidth) / 2
            let y = (imageHeight - cropHeight) / 2
            
            return CGRect(x: x, y: y, width: cropWidth, height: cropHeight)
        }
    }
    
    /// method to crop an image
    /// - Parameters:
    ///   - image: image to crop
    ///   - rect: rect size to apply to image
    /// - Returns: cropped ui image
    func cropImage(image: UIImage, toRect rect: CGRect) -> UIImage? {
        // convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        // create the crop filter
        let cropFilter = CIFilter(name: "CICrop")!
        cropFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        // define the crop rectangle
        cropFilter.setValue(CIVector(cgRect: rect), forKey: "inputRectangle")
        
        // get the cropped CIImage
        guard let croppedCIImage = cropFilter.outputImage else {
            return nil
        }
        
        // create a context to convert CIImage back to UIImage
        let context = CIContext()
        if let cgImage = context.createCGImage(croppedCIImage, from: croppedCIImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
}
