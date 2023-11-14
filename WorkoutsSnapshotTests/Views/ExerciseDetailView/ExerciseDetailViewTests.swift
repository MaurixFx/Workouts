//
//  ExerciseDetailViewTests.swift
//  WorkoutsSnapshotTests
//
//  Created by Mauricio Figueroa on 14-11-23.
//

import Foundation
import XCTest
import SnapshotTesting
@testable import Workouts

final class ExerciseDetailViewTests: XCTestCase {
    func test_view_looksGood_whenExerciseDoesNotHaveImagesAndVariations() {
        let exercise = Exercise(id: 1, name: "Jump Jump", description: "Jumping Jumping and dancing", images: [], variations: [])
        let viewModel = ExerciseDetailViewModel(exercise: exercise, coordinator: ExerciseCoordinatorManager(), isVariationExerciseDetail: false)
        
        let view = ExerciseDetailView(viewModel: viewModel)

        assertSnapshots(of: view, as: [.image(layout: .fixed(width: 375, height: 600))])
    }
    
    func test_view_looksGood_whenExerciseHasImagesCollectionAndDoesNotHaveVariations() {
        let exercise = Exercise(id: 1, name: "Jump Jump", description: "Jumping Jumping and dancing", images: [
            ExerciseImage(id: 1, isMain: true, image: ""),
            ExerciseImage(id: 2, isMain: true, image: "")
        ], variations: [])
        
        let viewModel = ExerciseDetailViewModel(exercise: exercise, coordinator: ExerciseCoordinatorManager(), isVariationExerciseDetail: false)
        
        let view = ExerciseDetailView(viewModel: viewModel)

        assertSnapshots(of: view, as: [.image(layout: .fixed(width: 375, height: 600))])
    }
}
