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
    
    private class ExerciseListViewController: UIViewController {
        private let viewModel: ExerciseListViewModelProtocol

        init(viewModel: ExerciseListViewModelProtocol = ExerciseListViewModel()) {
            self.viewModel = viewModel
            
            super.init(nibName: nil, bundle: nil)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            Task {
                await viewModel.loadExercises()
            }
        }
    }
    
    private class MockExerciseListViewModel: ExerciseListViewModelProtocol {
        var currentState: Workouts.ExerciseListViewModel.State = .loading
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
}
