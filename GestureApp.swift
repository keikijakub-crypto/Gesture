//
//  GestureApp.swift
//  Gesture
//
//  Created by Alena Jakub on 1/28/26.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct GestureApp: App {

    init(){
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        FirebaseApp.configure()
        print("Configured Firebase!")
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack{
                RootView()
            }
        }
    }
}
