//
//  ExerciseDetailViewModel.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import Foundation

final class ExerciseDetailViewModel: ObservableObject {
    
    private let exercise: Exercise
    private let service: ExerciseService
    private let coordinator: ExerciseCoordinator
    private let isVariationExerciseDetail: Bool
    @Published var exerciseVariations: [Exercise] = []
    
    // MARK: - Init
    
    init(exercise: Exercise, service: ExerciseService = ExerciseManager(), coordinator: ExerciseCoordinator, isVariationExerciseDetail: Bool) {
        self.exercise = exercise
        self.service = service
        self.coordinator = coordinator
        self.isVariationExerciseDetail = isVariationExerciseDetail
    }
    
    @MainActor
    func loadExerciseVariations() async {
        guard !isVariationExerciseDetail, let variations = exercise.variations else { return }

        if let exercices = try? await service.fetchVariations(for: variations) {
            exerciseVariations = exercices
        }
    }
    
    var name: String {
        exercise.name
    }
    
    var description: String {
        exercise.description.plainTextFromHTML ?? ""
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
    
    var exerciseImageViewModel: ExerciseImageViewModel {
        .init(exerciseImage: exercise.mainExerciseImage)
    }
    
    var exerciseImages: [ExerciseImage] {
        exercise.images ?? []
    }
    
    func exerciseItemViewModel(exercise: Exercise) -> ExerciseItemViewModel {
        .init(name: exercise.name, mainExerciseImage: exercise.mainExerciseImage)
    }
    
    func didSelectVariation(with exercise: Exercise) {
        coordinator.showExerciseDetail(with: exercise, isVariationExerciseDetail: true)
    }
}
