//
//  ExerciseSelectionViewViewModel.swift
//  Simpl Fitness
//
//  Created by Collin Holthaus on 6/11/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

class ExerciseSelectionViewViewModel: ObservableObject{
    @Published var userId: String = ""
    @Published var exercises = [Exercise]()

    init(){}
    
    func getUserId() -> String{
        guard let userId = Auth.auth().currentUser?.uid else{
            return ""
        }
        return userId;
    }
    
    func saveWorkout(exercises: Set<Exercise>, workoutName: String, category: String) {
        let newID = UUID().uuidString
        let newWorkout = Workout(
            id: newID,
            name: workoutName,
            createdDate: Date().timeIntervalSince1970)
        
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(getUserId())
            .collection("workouts")
            .document(newID)
            .setData(newWorkout.asDictionary())
        
        for exercise in exercises {
            db.collection("users")
                .document(getUserId())
                .collection("workouts")
                .document(newID)
                .collection("exercises")
                .document(exercise.id)
                .setData(exercise.asDictionary())
        }
    }
}
