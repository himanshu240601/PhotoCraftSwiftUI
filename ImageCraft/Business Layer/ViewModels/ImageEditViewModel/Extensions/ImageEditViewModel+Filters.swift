//
//  ImageEditViewModel+Filters.swift
//  ImageCraft
//
//  Created by Himanshu's MacBook on 03/10/24.
//

import Foundation
import UIKit
import CoreImage.CIFilterBuiltins

extension ImageEditViewModel {
    
    /// method to apply filter to image
    /// - Parameters:
    ///   - image: image to apply filter to
    ///   - filter: filter to apply on image
    /// - Returns: ui image with filter applied
    func applyFilter(to image: UIImage, filter: ImageFilter) -> UIImage? {
        let jpegData = image.jpegData(compressionQuality: 0)!
        let ciImage = CIImage(image: UIImage(data: jpegData)!)
        let context = CIContext()
        let filterToApply: CIFilter

        switch filter {
        case .original:
            return image
            
        case .warm:
            filterToApply = CIFilter.temperatureAndTint()
            filterToApply.setValue(CIVector(x: 6500, y: 0), forKey: "inputNeutral")
            
        case .cool:
            filterToApply = CIFilter.temperatureAndTint()
            filterToApply.setValue(CIVector(x: 4000, y: 0), forKey: "inputNeutral")
            
        case .blossom:
            filterToApply = CIFilter.bloom()
            filterToApply.setValue(0.8, forKey: kCIInputIntensityKey)
            
        case .sepia:
            filterToApply = CIFilter.sepiaTone()
            filterToApply.setValue(0.8, forKey: kCIInputIntensityKey)
            
        case .noir:
            filterToApply = CIFilter.photoEffectNoir()
            
        case .chrome:
            filterToApply = CIFilter.photoEffectChrome()
            
        case .instant:
            filterToApply = CIFilter.photoEffectInstant()
            
        case .fade:
            filterToApply = CIFilter.photoEffectFade()
            
        case .mono:
            filterToApply = CIFilter.photoEffectMono()
        }

        // set the input image for the selected filter
        filterToApply.setValue(ciImage, forKey: kCIInputImageKey)

        // get the filtered image output
        guard let outputImage = filterToApply.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
