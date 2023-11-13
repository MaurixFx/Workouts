//
//  ExerciseImageViewModel.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import Foundation

final class ExerciseImageViewModel {
    private let exerciseImage: ExerciseImage?
    
    // MARK: - Init

    init(exerciseImage: ExerciseImage?) {
        self.exerciseImage = exerciseImage
    }
    
    /// Returns an exercise image URL
    var exerciseImageURL: URL? {
        return URL(string: exerciseImage?.image ?? "")
    }
}
