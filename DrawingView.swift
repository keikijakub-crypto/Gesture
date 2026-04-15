//
//  DrawingView.swift
//  Gesture
//
//  Created by Alena Jakub on 4/14/26.
//

import SwiftUI

struct DrawingView: View {
    
    let promptURL: String
    
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @StateObject private var viewModel = DrawingViewModel()
    
    var body: some View{
        VStack{
            AsyncImage(url: URL(string: promptURL)){ image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            
            Button("Finish Drawing"){
                showCamera = true
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $showCamera){
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage){ newValue in
            if let image = newValue {
                Task {
                    await viewModel.uploadDrawing(
                        image: image,
                        promptURL: promptURL
                    )
                }
            }
        }
    }

}
