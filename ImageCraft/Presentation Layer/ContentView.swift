//
//  ContentView.swift
//  ImageCraft
//
//  Created by Himanshu's MacBook on 02/10/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    // MARK: - Properties
    
    // path variable for navigation stack
    @State var path = NavigationPath()
    
    // image picker
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var uiImage: UIImage?
    
    // MARK: - Body
    
    var body: some View {
        // main navigation stack
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Discover")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    PhotosPicker("Select image",
                         selection: $avatarItem,
                         matching: .images
                    )
                    .onChange(of: avatarItem, perform: { value in
                        Task {
                            // Retrieve selected asset in the form of Data
                            if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    path.append(uiImage)
                                }
                            }
                        }
                    })
                }
                
                
                Spacer()
            }
            .padding()
            // navigation destinations
            .navigationDestination(for: UIImage.self) { image in
                ImageEditView(selectedImage: image)
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    ContentView()
}
