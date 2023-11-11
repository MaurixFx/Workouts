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
        let (sut, service) = makeSUT()
        
        await sut.loadExercises()
        
        XCTAssertTrue(service.fetchWasCalled, "fetch method on ExerciseManager should have been called")
        XCTAssertEqual(service.fetchCallsCount, 1, "fetch method on ExerciseManager should have been called just once")
    }
    
    func test_loadExercises_setCurrentStateToError_whenExerciseManagerFails() async {
        let expectedError = APIError.invalidResponse
        let (sut, service) = makeSUT()
        service.fetchResult = .failure(expectedError)
        
        await sut.loadExercises()
        
        XCTAssertEqual(sut.currentState, .error(expectedError), "currentState should be .error when ExerciseManager fails")
    }
    
    func test_loadExercises_setCurrentStateToReloadCollection_whenExerciseManagerSucceeds() async {
        let (sut, service) = makeSUT()
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExercises()
        
        XCTAssertEqual(sut.currentState, .reloadCollection, "currentState should be .reloadCollection when ExerciseManager succeeds")
    }
    
    func test_loadExercises_setExercicesArrayList_whenExerciseManagerSucceeds() async throws {
        let (sut, service) = makeSUT()
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExercises()
        
        let exercices: [Exercise] = try XCTUnwrap(
            Mirror(reflecting: sut).child(named: "exercices")
        )
        
        XCTAssertEqual(exercices, anyExerciseResponse.results, "exercices array list should be equal to the expected exercies list")
    }
    
    func test_numberOfItems_returnsTheExpectedValue() async {
        let (sut, service) = makeSUT()
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExercises()
        
        XCTAssertEqual(sut.numberOfItems, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ExerciseListViewModel, service: MockExerciseManager) {
        let service = MockExerciseManager()
        let sut = ExerciseListViewModel(service: service)
        
        return (sut, service)
    }
    
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
}

extension Mirror {
    func child<T>(named name: String) -> T? {
        children.first(where: { $0.label == name })?.value as? T
    }
}
