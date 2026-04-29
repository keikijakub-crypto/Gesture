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
#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var promptURL: String?
    @Published var streak: Int = 0
    
    func generatePrompt() async {
        promptURL = "https://source.unsplash.com/random/800x800?drawing"
        
    }
    
    func loadStreak() async {
#if canImport(FirebaseFirestore)
        do {
            guard let user = Auth.auth().currentUser else { return }
            let uid = user.uid
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(uid)
            let snapshot = try await docRef.getDocument()
            if let data = snapshot.data(), let streakValue = data["streak"] as? Int {
                self.streak = streakValue
            } else {
                self.streak = 0
            }
        } catch {
            self.streak = 0
            print("Failed to load streak: \(error)")
        }
#else
        // Firestore is not available in this build configuration.
        // Keep a safe default and optionally log a message for debugging.
        self.streak = 0
        print("Firestore module not available; loadStreak() is a no-op.")
#endif
        // Fallback fetch in case the earlier Firestore-available branch didn't run this far
        guard let user = Auth.auth().currentUser else {
            // No authenticated user; keep default streak
            return
        }
#if canImport(FirebaseFirestore)
        do {
            let doc = try await Firestore.firestore()
                .collection("users")
                .document(user.uid)
                .getDocument()
            self.streak = doc.data()?[("currentStreak")] as? Int ?? self.streak
        } catch {
            // Preserve current streak value on error
            print("Failed to fetch currentStreak in fallback: \(error)")
        }
#else
        // Firestore not available; nothing further to do here
#endif
    }
    
    
}

