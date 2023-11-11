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
    
    func test_numberOfItemsInSection_returnsTheExpectValue() throws {
        let sut = makeSUT(expectedResult: .success(anyExerciseResponse.results))
        
        sut.loadViewIfNeeded()
        
        let datasource = sut.collectionView.dataSource!
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            XCTAssertEqual(datasource.collectionView(sut.collectionView, numberOfItemsInSection: 0), self.anyExerciseResponse.results.count, "")
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(expectedResult: Result<[Exercise], Error>) -> ExerciseListViewController {
        let service = MockExerciseManager()
        let viewModel = ExerciseListViewModel(service: service)
        let sut = ExerciseListViewController(viewModel: viewModel)
        
        service.fetchResult = expectedResult
        
        return sut
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
