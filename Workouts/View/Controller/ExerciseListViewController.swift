//
//  ExerciseListViewController.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
import UIKit

final class ExerciseListViewController: UIViewController {
    private let viewModel: ExerciseListViewModelProtocol

    // MARK: - Init

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
        
        load()
    }
    
    private func load() {
        Task {
            await viewModel.loadExercises()
        }
    }
}
