//
//  Enums.swift
//  ImageCraft
//
//  Created by Himanshu's MacBook on 02/10/24.
//

import CoreFoundation

// MARK: Image Edit Type
enum ImageEditType: String, CaseIterable {
    case none
    case crop
    case filters
    case adjust
}

// MARK: - Image Filters
enum ImageFilter: String, CaseIterable {
    case original
    case warm
    case cool
    case blossom
    case sepia
    case noir
    case chrome
    case instant
    case fade
    case mono
}

// MARK: - Crop Options
enum CropOptions: String, CaseIterable {
    case none
    case crop   = "crop"
    case rotate = "rectangle.landscape.rotate"
    case adjust = "perspective"
}

// MARK: - Crop Values
enum CropDimensions: String, CaseIterable {
    case free          = "Free"
    case oneByOne      = "1:1"
    case threeByFour   = "3:4"
    case nineBySixteen = "9:16"
    case twoByThree    = "2:3"
    case threeByFive   = "3:5"
    case fourByFive    = "4:5"
    case fiveBySeven   = "5:7"
    
    // get the aspect ratio (width:height)
    var aspectRatio: CGFloat {
        switch self {
        case .free:
            return 0
        case .oneByOne:
            return 1.0
        case .threeByFour:
            return 3.0 / 4.0
        case .nineBySixteen:
            return 9.0 / 16.0
        case .twoByThree:
            return 2.0 / 3.0
        case .threeByFive:
            return 3.0 / 5.0
        case .fourByFive:
            return 4.0 / 5.0
        case .fiveBySeven:
            return 5.0 / 7.0
        }
    }
}
