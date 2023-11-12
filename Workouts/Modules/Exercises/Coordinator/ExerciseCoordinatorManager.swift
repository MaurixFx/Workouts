//
//  ExerciseCoordinatorManager.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 12-11-23.
//

import Foundation
import UIKit
import SwiftUI

protocol ExerciseCoordinator {
    /// Return the UIViewController that should be used for presentation
    var presentationViewController: (() -> UIViewController?)? { get set }
    func showExerciseDetail(with exercise: Exercise)
}

final class ExerciseCoordinatorManager: ExerciseCoordinator {
    var presentationViewController: (() -> UIViewController?)?
    
    func showExerciseDetail(with exercise: Exercise) {
        guard let viewController = presentationViewController?() else { return }

        let viewModel = ExerciseDetailViewModel(exercise: exercise)
        let exerciseDetailView = ExerciseDetailView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: exerciseDetailView)
        
        viewController.navigationController?.pushViewController(hostingVC, animated: true)
    }
}
