//
//  ExerciseImageViewModel.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import Foundation

final class ExerciseImageViewModel {
    private let exerciseImage: ExerciseImage?
    
    init(exerciseImage: ExerciseImage?) {
        self.exerciseImage = exerciseImage
    }
    
    var exerciseImageURL: URL? {
        return URL(string: exerciseImage?.image ?? "")
    }
}
