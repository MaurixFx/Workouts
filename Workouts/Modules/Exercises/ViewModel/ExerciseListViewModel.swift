//
//  ExerciseListViewModel.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
import Combine

final class ExerciseListViewModel {
    private let service: ExerciseService
    private let coordinator: ExerciseCoordinator

    private var exercices: [Exercise] = []
    var currentState = CurrentValueSubject<State, Never>(.loading)
    
    private enum Constants {
        static let cellHeight: CGFloat = 260
        static let widthDivider: CGFloat = 2
    }

    enum State: Equatable {
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.reloadCollection, .reloadCollection):
                return true
            case let (.error(error1), .error(error2)):
                return type(of: error1) == type(of: error2) && "\(error1)" == "\(error2)"
            default:
                return false
            }
        }
        
        case loading
        case reloadCollection
        case error(Error)
    }
    
    // MARK: - Init
    
    init(service: ExerciseService = ExerciseManager(), coordinator: ExerciseCoordinator = ExerciseCoordinatorManager()) {
        self.service = service
        self.coordinator = coordinator
    }

    /// Loads exercises
    /// set state to .reloadCollection when fetch request is succesful
    /// set state to error when fetch request fails
    @MainActor
    func loadExercises() async {
        do {
            exercices = try await service.fetch()
            currentState.value = .reloadCollection
        } catch {
            currentState.value = .error(error)
        }
    }
    
    /// Returns number of exercises
    var numberOfItems: Int {
        exercices.count
    }
    
    /// Returns required item viewModel to display the data of the Exercise
    func exerciseListItemViewModel(for row: Int) -> ExerciseItemViewModel? {
        guard let item = getExerciseItem(for: row) else {
            return nil
        }
        
        return .init(name: item.name, mainExerciseImage: item.mainExerciseImage)
    }
    
    /// Returns the size for each collection view cell
    func cellSizeItem(with collectionWidth: CGFloat) -> CGSize {
        .init(width: collectionWidth / Constants.widthDivider, height: Constants.cellHeight)
    }
    
    private func getExerciseItem(for row: Int) -> Exercise? {
        guard row >= 0 && row < exercices.count else {
            return nil
        }
        
        return exercices[row]
    }
    
    /// Displays the exercise detail view
    /// parameter 'isVariationExerciseDetail' to false, because the intention is to display a exercise detail view
    func didSelectItem(for row: Int) {
        guard let item = getExerciseItem(for: row) else {
            return
        }
        
        coordinator.showExerciseDetail(with: item, isVariationExerciseDetail: false)
    }
}
