//
//  ExerciseListViewModel.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation

final class ExerciseListViewModel {
    private let service: ExerciseService
    private(set) var currentState: State = .initial
    private var exercices: [Exercise] = []
    
    private enum Constants {
        static let cellHeight: CGFloat = 200
        static let widthDivider: CGFloat = 2
    }
    
    enum State: Equatable {
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial):
                return true
            case (.reloadCollection, .reloadCollection):
                return true
            case let (.error(error1), .error(error2)):
                return type(of: error1) == type(of: error2) && "\(error1)" == "\(error2)"
            default:
                return false
            }
        }
        
        case initial
        case reloadCollection
        case error(Error)
    }
    
    // MARK: - Init
    
    init(service: ExerciseService) {
        self.service = service
    }

    func loadExercises() async {
        do {
            exercices = try await service.fetch()
            currentState = .reloadCollection
        } catch {
            currentState = .error(error)
        }
    }
    
    var numberOfItems: Int {
        exercices.count
    }
    
    func exerciseListItemViewModel(for row: Int) -> ExerciseItemViewModel? {
        guard row >= 0 && row < exercices.count else {
            return nil
        }
        
        let item = exercices[row]
        
        return .init(name: item.name, images: item.images)
    }
    
    func cellSizeItem(with collectionWidth: CGFloat) -> CGSize {
        .init(width: collectionWidth / Constants.widthDivider, height: Constants.cellHeight)
    }
}
