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
    // MARK: - spinnerLoaderView

    func test_spinnerLoaderView_shouldExistsOnTheViewController() throws {
        let sut = makeSUT(expectedResult: .success(anyExerciseResponse.results))

        let spinnerLoaderView: UIActivityIndicatorView = try XCTUnwrap(
            Mirror(reflecting: sut).child(named: "spinnerLoaderView")
        )
        
        XCTAssertNotNil(spinnerLoaderView, "spinnerLoaderView should exist on the viewController")
    }
    
    // MARK: - collectionView
    
    func test_collectionView_shouldExistsOnTheViewController() throws {
        let sut = makeSUT(expectedResult: .success(anyExerciseResponse.results))

        XCTAssertNotNil(sut.collectionView, "collectionView should exist on the viewController")
    }
    
    func test_delegate_shouldHaveBeenAssigned() throws {
        let sut = makeSUT(expectedResult: .success(anyExerciseResponse.results))

        XCTAssertNotNil(sut.collectionView.delegate, "collectionView delegate protocol should have been assigned")
    }
    
    func test_datasource_shouldHaveBeenAssigned() throws {
        let sut = makeSUT(expectedResult: .success(anyExerciseResponse.results))

        XCTAssertNotNil(sut.collectionView.dataSource, "collectionView datasource protocol should have been assigned")
    }
    
    // MARK: - viewDidLoad
    
    func test_viewDidLoad_shouldAddTwoViewComponentsToTheMainView() {
        let sut = makeSUT(expectedResult: .success(anyExerciseResponse.results))
        
        XCTAssertEqual(sut.view.subviews.count, 2, "viewDidLoad should have added two UI components to the main view")
    }
    
    // MARK: - numberOfItemsInSection
    
    func test_numberOfItemsInSection_returnsTheExpectValue() throws {
        let sut = makeSUT(expectedResult: .success(anyExerciseResponse.results))
        
        sut.loadViewIfNeeded()
        sut.load()
        
        let datasource = sut.collectionView.dataSource!
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            XCTAssertEqual(datasource.collectionView(sut.collectionView, numberOfItemsInSection: 0), self.anyExerciseResponse.results.count, "numberOfItemsInSection should be equal to the expected response")
        })
    }
    
    func test_numberOfItemsInSection_returnsTheZero_whenServiceResponseIsAFailure() throws {
        let sut = makeSUT(expectedResult: .failure(APIError.invalidResponse))
        
        sut.loadViewIfNeeded()
        sut.load()
        
        let datasource = sut.collectionView.dataSource!
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            XCTAssertEqual(datasource.collectionView(sut.collectionView, numberOfItemsInSection: 0), 0, "numberOfItemsInSection should be zero when service response is a failure")
        })
    }
    
    // MARK: - cellForRow
    
    func test_cellForRow_shouldDisplayTheExerciseDataInExerciseItemViewCell() throws {
        let expectedItems = anyExerciseResponse.results
        let sut = makeSUT(expectedResult: .success(expectedItems))
        let indexPath = IndexPath(row: 0, section: 0)
        
        sut.loadViewIfNeeded()
        sut.load()

        let dataSource = sut.collectionView.dataSource
        
        var exerciseItemCell: ExerciseItemViewCell?
        let itemViewModel = ExerciseItemViewModel(name: "Abs Abs", mainExerciseImage: nil)
        if let cell = dataSource?.collectionView(sut.collectionView, cellForItemAt: indexPath) as? ExerciseItemViewCell {
            exerciseItemCell = cell
            cell.displayItemExercise(with: itemViewModel)
            
            let nameLabel: UILabel = try XCTUnwrap(
                Mirror(reflecting: cell).child(named: "nameLabel")
            )
            
            XCTAssertEqual(nameLabel.text, itemViewModel.name, "The name displayed on the label should be equal to the name of the item")
        }
        
        XCTAssertNotNil(exerciseItemCell)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(expectedResult: Result<[Exercise], Error>) -> ExerciseListViewController {
        let service = MockExerciseManager()
        let viewModel = ExerciseListViewModel(service: service)
        let sut = ExerciseListViewController(viewModel: viewModel)
        
        service.fetchResult = expectedResult
        
        return sut
    }
}
