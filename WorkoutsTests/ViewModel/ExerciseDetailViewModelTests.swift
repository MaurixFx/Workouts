//
//  ExerciseDetailViewModelTests.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import Foundation
import XCTest
@testable import Workouts

final class ExerciseDetailViewModelTests: XCTestCase {
    func test_loadExerciseVariations_callsExerciseManager() async {
        let service = MockExerciseManager()
        let sut = ExerciseDetailViewModel(service: service)
        
        await sut.loadExerciseVariations()
        
        XCTAssertTrue(service.fetchVariationsWasCalled, "fetchVariations should have been called")
        XCTAssertEqual(service.fetchVariationsCallsCount, 1, "fetchVariations should have been called just once")
    }
    
    func test_loadExerciseVariations_doesNotSetTheExercisesResult_whenExerciseManagerFails() async throws {
        let expectedError = APIError.invalidResponse
        let service = MockExerciseManager()
        let sut = ExerciseDetailViewModel(service: service)
        service.fetchResult = .failure(expectedError)
        
        await sut.loadExerciseVariations()
        
        let exerciseVariations: [Exercise] = try XCTUnwrap(
            Mirror(reflecting: sut).child(named: "exerciseVariations")
        )
        
        XCTAssertTrue(exerciseVariations.isEmpty, "currentState should be .error when ExerciseManager fails")
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
    
    private class ExerciseDetailViewModel {
        
        private let service: ExerciseService
        private var exerciseVariations: [Exercise] = []
        
        init(service: ExerciseService = ExerciseManager()) {
            self.service = service
        }
        
        func loadExerciseVariations() async {
            if let exercices = try? await service.fetchVariations(for: [1]) {
                exerciseVariations = exercices
            }
        }
    }
}
