//
//  AuthenticationView.swift
//  Gesture
//
//  Created by Alena Jakub on 3/11/26.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        VStack{
            
            Text("Welcome to Gesture")
                .font(.title.monospaced().italic())
                .bold()
            
            NavigationLink{
                SignInEmailView(showSignInView: .constant(true))
            } label: {
                Text("Sign in with Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.brown)
                    .cornerRadius(10)
            }
            
            Spacer()
                
        }
        .padding()
        
            .navigationTitle("Sign In")
    }
}

struct AuthenticationView_Preview: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        SignInEmailView(showSignInView: $showSignInView)
    }
}

#Preview {
    AuthenticationView()
}
