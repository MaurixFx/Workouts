//
//  ExerciseDetailViewModel.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import Foundation

final class ExerciseDetailViewModel {
    
    private let exercise: Exercise
    private let service: ExerciseService
    private var exerciseVariations: [Exercise] = []
    
    init(exercise: Exercise, service: ExerciseService = ExerciseManager()) {
        self.exercise = exercise
        self.service = service
    }
    
    func loadExerciseVariations() async {
        if let exercices = try? await service.fetchVariations(for: [1]) {
            exerciseVariations = exercices
        }
    }
    
    var exerciseImageURL: URL? {
        guard let images = exercise.images else { return nil }
        
        return URL(string: images.first(where: { $0.isMain })?.image ?? "")
    }
    
    var name: String {
        exercise.name
    }
    
    var description: String {
        exercise.description
    }
    
    var shouldDisplayImagesSection: Bool {
        guard let images = exercise.images else {
            return false
        }
        
        return images.count > 1
    }
    
    var shouldDisplayVariationsSection: Bool {
        return exerciseVariations.count > 0
    }
}
