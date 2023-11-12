//
//  ExerciseDetailView.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    
    var body: some View {
        Text(exercise.name)
    }
}

#Preview {
    ExerciseDetailView(
        exercise: Exercise(id: 1,
                           name: "Abdominales",
                           description: "blalaalalal", 
                           images: [],
                           variations: [])
    )
}
