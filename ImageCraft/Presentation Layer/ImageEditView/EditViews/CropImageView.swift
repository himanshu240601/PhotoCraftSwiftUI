//
//  CropImageView.swift
//  ImageCraft
//
//  Created by Himanshu's MacBook on 03/10/24.
//

import SwiftUI

struct CropImageView: View {
    
    // MARK: - Properties
    
    // view model
    @EnvironmentObject var imageEditVM: ImageEditViewModel
    
    // slider values
    @State private var value: Double = 0
    @State private var step: Double = 1
    
    // MARK: - Body
    
    var body: some View {
        // crop suboptions
        ScrollView(.horizontal) {
            HStack {
                ForEach(CropDimensions.allCases, id: \.self) { value in
                    Text(value.rawValue)
                        .padding()
                        .opacity(
                            imageEditVM.checkSelectedCropDimension(selectedOption: value)
                            ? 1
                            : 0.25
                        )
                        .fontWeight(
                            imageEditVM.checkSelectedCropDimension(selectedOption: value)
                            ? .medium
                            : .regular
                        )
                        .onTapGesture {
                            withAnimation {
                                imageEditVM.selectedCropValue = value
                            }
                        }
                }
            }
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    CropImageView()
        .environmentObject(ImageEditViewModel())
}
