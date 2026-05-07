//
//  DrawingViewModel.swift
//  Gesture
//
//  Created by Alena Jakub on 4/15/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit
import Combine

@MainActor
class DrawingViewModel: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    
    
    func uploadDrawing(image: UIImage, promptURL: String) async {
        
        guard let user = Auth.auth().currentUser else{return}
        
        do{
            let imageURL = try await uploadImage(image, userId: user.uid)
            
            try await saveDrawing (
                userId: user.uid,
                promptURL: promptURL,
                drawingURL: imageURL
            )
            
            try await updateStreak(userId: user.uid)
        } catch {
            print(error)
        }
    }
    
    private func uploadImage(_ image: UIImage, userId: String) async throws -> String {
        let data = image.jpegData(compressionQuality: 0.8)!
        
        let ref = Storage.storage()
            .reference()
            .child("drawings/\(userId)/\(UUID().uuidString).jpg")

        _ = try await ref.putDataAsync(data)
        
        return try await ref.downloadURL().absoluteString
    }
    
    private func saveDrawing(userId: String, promptURL: String, drawingURL: String) async throws {
        try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("drawings")
            .addDocument(data: [
                "promptURL": promptURL,
                "drawingURL": drawingURL,
                "date": Timestamp()
            ]
            )
    }
    
    private func updateStreak(userId: String) async throws {
        
        let ref = Firestore.firestore()
            .collection("users")
            .document(userId)
        
        let doc = try await ref.getDocument()
        
        let today = Calendar.current.startOfDay(for: Date())
        
        let lastDate = (doc.data()?["lastDrawDate"] as? Timestamp)?.dateValue()
        var streak = doc.data()?["currentStreak"] as? Int ?? 0
        
        if let last = lastDate{
            let diff = Calendar.current.dateComponents([.day], from: last, to: today).day!
            
            if diff == 1{
                streak += 1
            } else if diff > 1{
                streak = 1
            } else {
                return
            }
        } else {
            streak = 1
        }
        
        try await ref.setData([
            "currentStreak": streak,
            "lastDrawDate": Timestamp(date: today)
        ], merge: true)
    }
}

