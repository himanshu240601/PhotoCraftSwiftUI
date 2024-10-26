//
//  ImageEditView.swift
//  ImageCraft
//
//  Created by Himanshu's MacBook on 02/10/24.
//

import SwiftUI

struct ImageEditView: View {
    
    // MARK: - Properties
    
    // environment object
    @StateObject var imageEditVM = ImageEditViewModel()
    
    // environment values
    @Environment(\.dismiss) var dismiss
    
    // filter images
    @State var filterImages: [ImageFilter: UIImage] = [:]
    
    @State var selectedImage: UIImage = UIImage(named: "sample")!
    
    // original image used for cropping and appying effects
    @State var originalImage: UIImage = UIImage(named: "sample")!
    
    // original size of image
    @State var imageOriginalSize: CGSize = .zero
    
    // constant view values
    var editSelectionCircleIndicatorSize: CGFloat = 5
    
    var mainImageViewCornerRadius: CGFloat = 8
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // top bar
            Text(Strings.AppInfo.appName)
                .frame(maxWidth: .infinity)
                .overlay {
                    HStack {
                        // back button
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: Strings.Icons.chevronLeft.rawValue)
                        }
                        .tint(.black)

                        Spacer()
                        
                        // save button
                        Button {
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: selectedImage)
                        } label: {
                            Image(systemName: Strings.Icons.squareArrowDown.rawValue)
                        }
                        .tint(.black)
                    }
                }
            
            Spacer()
            
            // image edit view
            Image(uiImage: selectedImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(
                    RoundedRectangle(
                        cornerSize: CGSize(width: mainImageViewCornerRadius, height: mainImageViewCornerRadius)
                    )
                )
                .padding(.vertical)
                .layoutPriority(1)
                .onChange(of: imageEditVM.selectedImageFilter) { filter in
                    selectedImage = imageEditVM.applyFilter(to: selectedImage, filter: imageEditVM.selectedImageFilter) ?? UIImage(named: "sample")!
                }
                .onChange(of: imageEditVM.selectedCropValue) { crop in
                    // calculate the crop rect based on the image size and the chosen dimension
                    let cropRect = imageEditVM.calculateCropRect(imageSize: imageOriginalSize, for: crop)
                    // use this cropRect to crop the image
                    selectedImage = imageEditVM.cropImage(image: originalImage, toRect: cropRect) ?? UIImage(named: "sample")!
                }
            
            Spacer()
            
            // switch to check what type of editing tools to show
            switch imageEditVM.selectedEditType {
            case .none:
                EmptyView()
            case .crop:
                CropImageView()
                    .environmentObject(imageEditVM)
            case .filters:
                FiltersView(filterImages: $filterImages)
                    .environmentObject(imageEditVM)
            case .adjust:
                AdjustImageView()
            }
            
            // image edit type selection
            HStack(spacing: 16) {
                Spacer()
                
                ForEach(ImageEditType.allCases, id: \.self) { type in
                    // do not show any view for type none
                    if type != .none && type != .adjust {
                        Text(type.rawValue.capitalized)
                            .foregroundStyle(imageEditVM.checkSelectedType(selectionType: type) ? Color.primary : Color.gray)
                            .fontWeight(imageEditVM.checkSelectedType(selectionType: type) ? .medium : .regular)
                            // view tap gesture
                            .onTapGesture {
                                withAnimation {
                                    if imageEditVM.checkSelectedType(selectionType: type) {
                                        imageEditVM.selectedEditType = .none
                                    } else {
                                        imageEditVM.selectedEditType = type
                                    }
                                }
                            }
                            .padding(.bottom, 8)
                            // selection indicator circle
                            .overlay(alignment: .bottom) {
                                if imageEditVM.checkSelectedType(selectionType: type) {
                                    Circle()
                                        .fill(Color.yellow)
                                        .frame(width: editSelectionCircleIndicatorSize, height: editSelectionCircleIndicatorSize)
                                }
                            }
                    }
                }
                
                Spacer()
            }
            .padding(.top)
        }
        .padding([.horizontal, .bottom])
        .padding(.top, 12)
        .onAppear {
            // set original image size
            imageOriginalSize = selectedImage.size
            originalImage = selectedImage
            // when view appears load filter images
            Task {
                for filter in ImageFilter.allCases {
                    let uiImage = imageEditVM.applyFilter(to: selectedImage, filter: filter)
                    filterImages[filter] = uiImage
                }
            }
        }
        // view overlay for progress view
        .overlay(alignment: .center) {
            // show progress view for loading tools related to
            // image editing and filters 
            if filterImages.count != ImageFilter.allCases.count {
                ProgressView()
                    .padding()
                    .tint(.white)
                    .background(.gray.opacity(0.5))
                    .clipShape(
                        RoundedRectangle(
                            cornerSize: CGSize(width: 8, height: 8)
                        )
                    )
            }
        }
    }
}

#Preview {
    ImageEditView()
}
