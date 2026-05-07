//
//  HomeViewModel.swift
//  Gesture
//
//  Created by Alena Jakub on 4/14/26.
//

import Foundation
import FirebaseAuth
import Firebase
import Combine
import FirebaseFirestore

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var promptURL: String?
    @Published var streak: Int = 0
    
    func generatePrompt() async {
        promptURL = "https://fastly.picsum.photos/id/244/4288/2848.jpg?hmac=R6j9PBP4aBk2vcEIoOPU4R_nuknizryn2Vq8GGtWTrM"
        
    }
    
    func loadStreak() async {
        do {
            guard let user = Auth.auth().currentUser else { return }
            let uid = user.uid
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(uid)
            let snapshot = try await docRef.getDocument()

            if let data = snapshot.data(), let streakValue = data["streak"] as? Int {
                // Increment the streak locally
                self.streak = streakValue + 1
                
                // If you want to persist the increment back to Firestore, uncomment below:
                try? await docRef.updateData(["streak": self.streak])
            } else {
                self.streak = 0
            }
        } catch {
            self.streak = 0
            print("Failed to load streak: \(error)")
        }
    }
    
    
}

