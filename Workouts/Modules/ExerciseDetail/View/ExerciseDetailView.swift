//
//  ExerciseDetailView.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import SwiftUI

struct ExerciseDetailView: View {
    let viewModel: ExerciseDetailViewModel
    
    var body: some View {
        Text(viewModel.name)
    }
}

#Preview {
    let viewModel = ExerciseDetailViewModel(exercise: Exercise(id: 1,
                                                                      name: "Abdominales",
                                                                      description: "As a warmup, use light dumbbells, one in each hand. Lunge in alternating directions, forward, sideways, backwards and 45 degree angles.",
                                                                      images: [
                                                                       ExerciseImage(id: 2, isMain: true, image: "")
                                                                              ],
                                                                      variations: []))

    return ExerciseDetailView(viewModel: viewModel)
}
