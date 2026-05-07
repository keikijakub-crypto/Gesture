//
//  HomeView.swift
//  Gesture
//
//  Created by Alena Jakub on 4/8/26.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = HomeViewModel()
    @State private var navigateToDrawing = false
    
    var body: some View {
        VStack(spacing: 25){
            
            Text("Gesture")
                .font(.largeTitle)
                .bold()
            
            Text("Draw daily")
                .font(.footnote)
                .italic()
            
            Text("Streak: \(viewModel.streak) ")
                .font(.title2)
            
            Button {
                Task{
                    await viewModel.generatePrompt()
                    navigateToDrawing = true

                }
            } label: {
                Text("Draw")
                    .font(.headline)
                    .foregroundStyle(Color(.white))
                    .frame(maxWidth: 200, alignment: .init(horizontal: .center, vertical: .center))
                    .frame(height: 55)
                    .background(Color.brown)
                    .cornerRadius(10)
            }
            //fixing the button
            NavigationLink(isActive: $navigateToDrawing) {
                Group {
                    if let url = viewModel.promptURL {
                        DrawingView(promptURL: url)
                    } else {
                        ProgressView()
                    }
                }
            } label: {
                EmptyView()
            }
            
            Spacer()
            
            Button("Log Out"){
                do {
                    try AuthenticationManager.shared.signOut()
                    showSignInView = true
                } catch {
                    print(error)
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadStreak()
        }
    }
}

