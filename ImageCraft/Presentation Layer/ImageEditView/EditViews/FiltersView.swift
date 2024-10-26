//
//  FiltersView.swift
//  ImageCraft
//
//  Created by Himanshu's MacBook on 03/10/24.
//

import SwiftUI

struct FiltersView: View {
    
    // MARK: - Properties
    
    // environment values
    @EnvironmentObject var imageEditVM: ImageEditViewModel
    
    // filter images
    @Binding var filterImages: [ImageFilter: UIImage]
    
    // view values
    var filterImageViewSize: CGFloat = 100
    var filterImageViewCornerRadius: CGFloat = 8
    var filterImageViewBorderWidth: CGFloat = 2
    
    // MARK: - Body
    
    var body: some View {
        // filters selection
        ScrollView(.horizontal) {
            HStack {
                ForEach(ImageFilter.allCases, id: \.self) { filter in
                    Image(uiImage: filterImages[filter] ?? UIImage(named: "sample")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: filterImageViewSize, height: filterImageViewSize)
                        // overlay text to show type of filter
                        .overlay {
                            Text(filter.rawValue.capitalized)
                                .font(.caption)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.black.opacity(0.1))
                                .foregroundStyle(.white)
                        }
                        // border radius
                        .overlay {
                            if imageEditVM.checkSelectedFilter(selectionFilter: filter) {
                                RoundedRectangle(cornerRadius: filterImageViewCornerRadius)
                                    .strokeBorder(Color.white, lineWidth: filterImageViewBorderWidth)
                                    .background(
                                        RoundedRectangle(cornerRadius: filterImageViewCornerRadius)
                                            .fill(Color.clear)
                                    )
                                    .frame(width: filterImageViewSize - 3, height: filterImageViewSize - 3)
                            }
                        }
                        // clip the image view shape to rounded rectangle
                        .clipShape(
                            RoundedRectangle(
                                cornerSize: CGSize(width: filterImageViewCornerRadius, height: filterImageViewCornerRadius)
                            )
                        )
                        // tap gesture for image view
                        .onTapGesture {
                            withAnimation { imageEditVM.selectedImageFilter = filter }
                        }
                }
            }
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    FiltersView(filterImages: .constant([:]))
        .environmentObject(ImageEditViewModel())
}
