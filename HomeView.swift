//
//  landingPage.swift
//  Gesture
//
//  Created by Alena Jakub on 4/8/26.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 25){
            
            Text("Draw Daily")
                .font(.largeTitle)
                .bold()
            
            Text("Streak: \(viewModel.streak) ")
                .font(.title2)
            
            Button("Draw!"){
                Task{
                    await viewModel.generatePrompt()
                }
            }
            .buttonStyle(.borderedProminent)
            
            if let url = viewModel.promptURL {
                AsyncImage(url: URL(string: url)){image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                } placeholder: {
                    ProgressView()
                }
                
                NavigationLink("Start Drawing"){
                    DrawingView(promptURL: url)
                }
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

