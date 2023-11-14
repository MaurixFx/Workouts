//
//  ExerciseItemViewTests.swift
//  WorkoutsSnapshotTests
//
//  Created by Mauricio Figueroa on 14-11-23.
//

import Foundation
import XCTest
import SnapshotTesting
@testable import Workouts

final class ExerciseItemViewTests: XCTestCase {
    func test_view_looksGood() {
        let viewModel = ExerciseItemViewModel(name: "Jump Jump", mainExerciseImage: ExerciseImage(id: 1, isMain: true, image: ""))
        let view = ExerciseItemView(viewModel: viewModel)
        
        assertSnapshots(of: view, as: [.image(precision: 0.95, layout: .fixed(width: 220, height: 270))])
    }
}
