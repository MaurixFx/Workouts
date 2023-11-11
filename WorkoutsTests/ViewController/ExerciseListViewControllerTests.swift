//
//  ExerciseListViewControllerTests.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
import XCTest
@testable import Workouts

final class ExerciseListViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_callExerciseViewModel() {
        let expectation = expectation(description: "loadExercises should be called")
        let viewModel = MockExerciseListViewModel()
        let sut = ExerciseListViewController(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(viewModel.loadExercisesWasCalled, "loadExercises on ExerciseListViewModel should have been called")
            XCTAssertEqual(viewModel.loadExercisesCallsCount, 1, "loadExercises on ExerciseListViewModel should have been called just once")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
