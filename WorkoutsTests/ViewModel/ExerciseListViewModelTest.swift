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
    func test_init_currentStateShouldBeLoading() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertTrue(sut.currentState.value == .loading)
    }
    
    func test_loadExercises_callsExerciseManager() async {
        let (sut, service, _) = makeSUT()
        
        await sut.loadExercises()
        
        XCTAssertTrue(service.fetchWasCalled, "fetch method on ExerciseManager should have been called")
        XCTAssertEqual(service.fetchCallsCount, 1, "fetch method on ExerciseManager should have been called just once")
    }
    
    func test_loadExercises_setCurrentStateToError_whenExerciseManagerFails() async {
        let expectedError = APIError.invalidResponse
        let (sut, service, _) = makeSUT()
        service.fetchResult = .failure(expectedError)
        
        await sut.loadExercises()
        
        XCTAssertEqual(sut.currentState.value, .error(expectedError), "currentState should be .error when ExerciseManager fails")
    }
    
    func test_loadExercises_setCurrentStateToReloadCollection_whenExerciseManagerSucceeds() async {
        let (sut, service, _) = makeSUT()
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExercises()
        
        XCTAssertEqual(sut.currentState.value, .reloadCollection, "currentState should be .reloadCollection when ExerciseManager succeeds")
    }
    
    func test_loadExercises_setExercicesArrayList_whenExerciseManagerSucceeds() async throws {
        let (sut, service, _) = makeSUT()
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExercises()
        
        let exercices: [Exercise] = try XCTUnwrap(
            Mirror(reflecting: sut).child(named: "exercices")
        )
        
        XCTAssertEqual(exercices, anyExerciseResponse.results, "exercices array list should be equal to the expected exercies list")
    }
    
    func test_numberOfItems_returnsExpectedValue() async {
        let (sut, service, _) = makeSUT()
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExercises()
        
        XCTAssertEqual(sut.numberOfItems, 1, "should have returned 1 since the array just have one item")
    }
    
    func test_exerciseItemViewModel_returnsNil_whenRowDoesNotExist() async {
        let (sut, service, _) = makeSUT()
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExercises()
        
        XCTAssertEqual(sut.exerciseListItemViewModel(for: 3), nil, "should have returned nil, since the row 3 does not exist")
    }
    
    func test_exerciseItemViewModel_returnsExpectedValue_whenRowExists() async {
        let (sut, service, _) = makeSUT()
        service.fetchResult = .success(anyExerciseResponse.results)
        let expectedItemViewModel = ExerciseItemViewModel(name: "Abs Abs", mainExerciseImage: nil)
        
        await sut.loadExercises()

        XCTAssertEqual(sut.exerciseListItemViewModel(for: 0), expectedItemViewModel, "should have returned the expectedItemViewModel")
    }
    
    func test_cellSizeItem_returnsExpectedValue() async {
        let (sut, service, _) = makeSUT()
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExercises()

        XCTAssertEqual(sut.cellSizeItem(with: 400), .init(width: 200, height: 260))
    }
    
    func test_didSelectItem_callsCoordinator_whenExerciseItemExists() async {
        let (sut, service, coordinator) = makeSUT()
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExercises()
        sut.didSelectItem(for: 0)
        
        XCTAssertTrue(coordinator.showExerciseDetailWasCalled, "showExerciseDetail should have been called")
        XCTAssertEqual(coordinator.showExerciseDetailCallsCount, 1, "showExerciseDetail should have been called just once")
    }
    
    func test_didSelectItem_doesNotcallCoordinator_whenExerciseItemDoesNotExist() async {
        let (sut, service, coordinator) = makeSUT()
        service.fetchResult = .success(anyExerciseResponse.results)
        
        await sut.loadExercises()
        sut.didSelectItem(for: 4)
        
        XCTAssertTrue(coordinator.showExerciseDetailWasCalled == false, "showExerciseDetail should have not been called when the exercise item does not exist")
        XCTAssertEqual(coordinator.showExerciseDetailCallsCount, 0, "showExerciseDetail should have not been when the exercise item does not exist")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ExerciseListViewModel, service: MockExerciseManager, coordinator: MockExerciseCoordinator) {
        let service = MockExerciseManager()
        let coordinator = MockExerciseCoordinator()
        let sut = ExerciseListViewModel(service: service, coordinator: coordinator)
        
        return (sut, service, coordinator)
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
