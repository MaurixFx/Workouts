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
        let (sut, _) = makeSUT()

        let spinnerLoaderView: UIActivityIndicatorView = try XCTUnwrap(
            Mirror(reflecting: sut).child(named: "spinnerLoaderView")
        )
        
        XCTAssertNotNil(spinnerLoaderView, "spinnerLoaderView should exist on the viewController")
    }
    
    func test_collectionView_shouldExistsOnTheViewController() throws {
        let (sut, _) = makeSUT()

        XCTAssertNotNil(sut.collectionView, "collectionView should exist on the viewController")
    }
    
    func test_delegate_shouldHaveBeenAssigned() throws {
        let (sut, _) = makeSUT()

        XCTAssertNotNil(sut.collectionView.delegate, "collectionView delegate protocol should have been assigned")
    }
    
    func test_datasource_shouldHaveBeenAssigned() throws {
        let (sut, _) = makeSUT()

        XCTAssertNotNil(sut.collectionView.dataSource, "collectionView datasource protocol should have been assigned")
    }
    
    func test_viewDidLoad_shouldAddTwoViewComponentsToTheMainView() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.view.subviews.count, 2, "viewDidLoad should have added two UI components to the main view")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ExerciseListViewController, service: MockExerciseManager) {
        let service = MockExerciseManager()
        let viewModel = ExerciseListViewModel(service: service)
        let sut = ExerciseListViewController(viewModel: viewModel)
        
        service.fetchResult = .success(anyExerciseResponse.results)
        
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
