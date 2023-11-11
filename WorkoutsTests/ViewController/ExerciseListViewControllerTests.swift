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
    func test_spinnerLoaderView_shouldExistsOnTheViewController() throws {
        let service = MockExerciseManager()
        let viewModel = ExerciseListViewModel(service: service)
        let sut = ExerciseListViewController(viewModel: viewModel)

        let spinnerLoaderView: UIActivityIndicatorView = try XCTUnwrap(
            Mirror(reflecting: sut).child(named: "spinnerLoaderView")
        )
        
        XCTAssertNotNil(spinnerLoaderView, "spinnerLoaderView should exist on the viewController")
    }
    
    func test_viewDidLoad_shouldAddTwoViewComponentsToTheMainView() {
        let service = MockExerciseManager()
        let viewModel = ExerciseListViewModel(service: service)
        let sut = ExerciseListViewController(viewModel: viewModel)
        
        XCTAssertEqual(sut.view.subviews.count, 2, "viewDidLoad should have added two UI components to the main view")
    }
}
