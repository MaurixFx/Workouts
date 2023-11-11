//
//  MockExerciseListViewModel.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
import Combine
@testable import Workouts

final class MockExerciseListViewModel: ExerciseListViewModelProtocol {
    var currentState: CurrentValueSubject<ExerciseListViewModel.State, Never> = CurrentValueSubject<ExerciseListViewModel.State, Never>(.loading)
    
    var numberOfItems: Int {
        return 0
    }
    
    private(set) var loadExercisesWasCalled = false
    private(set) var loadExercisesCallsCount = 0
    func loadExercises() async {
        loadExercisesWasCalled = true
        loadExercisesCallsCount += 1
    }
    
    func exerciseListItemViewModel(for row: Int) -> ExerciseItemViewModel? {
        return nil
    }
    
    func cellSizeItem(with collectionWidth: CGFloat) -> CGSize {
        return .zero
    }
}
