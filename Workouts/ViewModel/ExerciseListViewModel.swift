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
}
