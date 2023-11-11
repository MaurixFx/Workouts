//
//  ExerciseListViewModelTest.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
import XCTest
@testable import Workouts

final class ExerciseListViewModelTest: XCTestCase {
    func test_loadExercises_callsExerciseManager() async {
        let service = MockExerciseManager()
        let sut = ExerciseListViewModel(service: service)
        
        await sut.loadExercises()
        
        XCTAssertTrue(service.fetchWasCalled, "fetch method on ExerciseManager should have been called")
        XCTAssertEqual(service.fetchCallsCount, 1, "fetch method on ExerciseManager should have been called just once")
    }
    
    func test_loadExercises_setCurrentStateToError_whenExerciseManagerFails() async {
        let expectedError = APIError.invalidResponse
        let service = MockExerciseManager()
        let sut = ExerciseListViewModel(service: service)
        service.fetchResult = .failure(expectedError)
        
        await sut.loadExercises()
        
        XCTAssertEqual(sut.currentState, .error(expectedError), "currentState should be .error when ExerciseManager fails")
    }
    
    func test_loadExercises_setCurrentStateToReloadCollection_whenExerciseManagerSucceeds() async {
        let service = MockExerciseManager()
        let sut = ExerciseListViewModel(service: service)
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExercises()
        
        XCTAssertEqual(sut.currentState, .reloadCollection, "currentState should be .reloadCollection when ExerciseManager succeeds")
    }
    
    // MARK: - Helpers
    
    private var anyExerciseResponse: ExerciseResponse {
        .init(results: [
            Exercise(id: 4,
                     name: "Abs Abs",
                     description: "bla bla bla bla",
                     images: [],
                     variations: []
                    )
        ])
    }
    
    private class ExerciseListViewModel {
        private let service: ExerciseService
        
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
        
        private(set) var currentState: State = .initial
        
        init(service: ExerciseService) {
            self.service = service
        }

        func loadExercises() async {
            do {
                _ = try await service.fetch()
                currentState = .reloadCollection
            } catch {
                currentState = .error(error)
            }
        }
    }
    
    private class MockExerciseManager: ExerciseService {
        private(set) var fetchWasCalled = false
        private(set) var fetchCallsCount = 0
        var fetchResult: Result<[Exercise], Error>?

        func fetch() async throws -> [Exercise] {
            fetchWasCalled = true
            fetchCallsCount += 1
            
            return try await withCheckedThrowingContinuation { continuation in
                guard let fetchResult else {
                    continuation.resume(throwing: APIError.invalidResponse)
                    return
                }
                
                switch fetchResult {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let exercises):
                    continuation.resume(returning: exercises)
                }
            }
        }
    }
}