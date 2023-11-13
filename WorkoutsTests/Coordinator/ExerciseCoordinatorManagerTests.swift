//
//  ExerciseCoordinatorManager.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 13-11-23.
//

import Foundation
import XCTest
import SwiftUI
@testable import Workouts

final class ExerciseCoordinatorManagerTests: XCTestCase {
    func test_showExerciseDetail_presentsHostingViewControllerWithExerciseDetailView_whenPresentationViewControllerHasBeenSet() {
        let expectation = expectation(description: "HostingViewController presentation")

        let (sut, navigationController) = makeSUT()
        
        sut.presentationViewController = {
            expectation.fulfill()
            return navigationController
        }
        
        let delegate = MockViewControllerDelegate()
        navigationController.delegate = delegate
        
        sut.showExerciseDetail(with: anyExercise, isVariationExerciseDetail: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(delegate.didPresentViewController, "HostViewController should have been presented")
            
            if let hostingController = navigationController.topViewController as? UIHostingController<ExerciseDetailView> {
                XCTAssertNotNil(hostingController.rootView, "hostingController should contains the rootView")
            } else {
                XCTFail("The presented ViewController is not UIHostingController<ExerciseDetailView>")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_showExerciseDetail_doesNotPresentHostingViewControllerWithExerciseDetailView_whenPresentationViewControllerHasNotBeenSet() {
        let expectation = expectation(description: "HostingViewController presentation")

        let (sut, navigationController) = makeSUT()
        
        sut.presentationViewController = {
            expectation.fulfill()
            return nil
        }
        
        let delegate = MockViewControllerDelegate()
        navigationController.delegate = delegate
    
        sut.showExerciseDetail(with: anyExercise, isVariationExerciseDetail: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNil(delegate.didPresentViewController, "HostViewController should have not been presented")
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Helper
    
    private func makeSUT() -> (sut: ExerciseCoordinatorManager, navigationController: UINavigationController) {
        let coordinator = ExerciseCoordinatorManager()
        let baseViewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: baseViewController)
        
        return (coordinator, navigationController)
    }
    
    private var anyExercise: Exercise {
        Exercise(id: 1, name: "Jumping high", description: "Super jump", images: [], variations: [])
    }
    
    private class MockViewControllerDelegate: NSObject, UINavigationControllerDelegate {
        var didPresentViewController: ((UIViewController) -> Void)?

        func navigationController(
            _ navigationController: UINavigationController,
            didShow viewController: UIViewController,
            animated: Bool
        ) {
            didPresentViewController?(viewController)
        }
    }
}
