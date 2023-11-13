//
//  MockExerciseCoordinatorManager.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 13-11-23.
//

import Foundation
import UIKit
@testable import Workouts

final class MockExerciseCoordinator: ExerciseCoordinator {
    var presentationViewController: (() -> UIViewController?)?
    private(set) var showExerciseDetailCallsCount = 0
    private(set) var showExerciseDetailWasCalled = false

    func showExerciseDetail(with exercise: Exercise, isVariationExerciseDetail: Bool) {
        showExerciseDetailWasCalled = true
        showExerciseDetailCallsCount += 1
    }
}
