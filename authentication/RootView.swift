//
//  RootView.swift
//  Gesture
//
//  Created by Alena Jakub on 3/25/26.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack{
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented: $showSignInView){
            NavigationStack{
                AuthenticationView()
            }
        }
    }
    
}

#Preview {
    RootView()
}
