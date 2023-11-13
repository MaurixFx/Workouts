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
    
    /// Requests exercises variations
    /// When the view is not a variation exercise detail view and the array of variationIDs is not nil
    /// Set a list of exercises when fetch variations request is succesful
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
    
    /// Returns a description text converted from HTML if needed
    var description: String {
        exercise.description.plainTextFromHTML ?? ""
    }
    
    /// Returns whether the view should display the image section or not
    /// If the exercise has more than one image, returns true, otherwise returns false
    var shouldDisplayImagesSection: Bool {
        guard let images = exercise.images else {
            return false
        }
        
        return images.count > 1
    }
    
    /// Returns whether the view should display the variations section or not
    /// If the exercise variations list is bigger than zero, returns true, otherwise returns false
    var shouldDisplayVariationsSection: Bool {
        return exerciseVariations.count > 0
    }
    
    /// Returns a viewModel which contains the main exercise image
    var exerciseImageViewModel: ExerciseImageViewModel {
        .init(exerciseImage: exercise.mainExerciseImage)
    }
    
    /// Returns an array of exercise images
    var exerciseImages: [ExerciseImage] {
        exercise.images ?? []
    }
    
    /// Returns a item viewModel to display the exercise variation info
    func exerciseItemViewModel(exercise: Exercise) -> ExerciseItemViewModel {
        .init(name: exercise.name, mainExerciseImage: exercise.mainExerciseImage)
    }
    
    /// Displays the exercise variation detial
    /// parameter 'isVariationExerciseDetail' to true, because the intention is to display a variation detail view
    func didSelectVariation(with exercise: Exercise) {
        coordinator.showExerciseDetail(with: exercise, isVariationExerciseDetail: true)
    }
}
