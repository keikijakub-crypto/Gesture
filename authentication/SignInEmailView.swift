//
//  SignInEmailView.swift
//  Gesture
//
//  Created by Alena Jakub on 3/18/26.
//

import SwiftUI
import Combine

@MainActor
final class SignInEmailModel: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn(){
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        Task {
            do{
                let returnUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnUserData)
            } catch {
                print("Error: \(error)")
                
            }
        }
        
    }
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Email...", text:$viewModel.email)
                .padding()
                .background(Color.brown.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password...", text:$viewModel.password)
                .padding()
                .background(Color.brown.opacity(0.4))
                .cornerRadius(10)
            
            Button{
                viewModel.signIn()
                showSignInView = false
            } label:{
                Text("Sign In.")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.brown)
                    .cornerRadius(10)
            }
            
            Spacer()
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding()
        .navigationTitle("Sign in With Email")
    }
}
#Preview {
    NavigationView {
        SignInEmailView(showSignInView: .constant(true))
    }
}
