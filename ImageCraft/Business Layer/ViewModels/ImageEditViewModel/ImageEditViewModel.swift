//
//  ImageEditViewModel.swift
//  ImageCraft
//
//  Created by Himanshu's MacBook on 02/10/24.
//

import Foundation
import CoreImage
import UIKit

class ImageEditViewModel: ObservableObject {
    
    // MARK: - Properties
    
    // selected image edit feature
    @Published var selectedEditType: ImageEditType = .none
    // selected image filter
    @Published var selectedImageFilter: ImageFilter = .original
    // selected crop value
    @Published var selectedCropValue: CropDimensions = .free
    
    // MARK: - Methods
    
    /// method to check if given type is already selected
    /// - Parameter type: selections values to check for
    /// - Returns: a boolean value
    func checkSelectedType(selectionType type:  ImageEditType) -> Bool {
        return selectedEditType == type
    }
    
    /// method to check if given filter is already selected
    /// - Parameter filter: filter type to check for
    /// - Returns: a boolean value
    func checkSelectedFilter(selectionFilter filter: ImageFilter) -> Bool {
        return selectedImageFilter == filter
    }
    
    /// method to check if given crop dimension is already selected
    /// - Parameter option: crop dimension to check for
    /// - Returns: a boolean value
    func checkSelectedCropDimension(selectedOption option: CropDimensions) -> Bool {
        return selectedCropValue == option
    }
}

// MARK: Image Saver
class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
