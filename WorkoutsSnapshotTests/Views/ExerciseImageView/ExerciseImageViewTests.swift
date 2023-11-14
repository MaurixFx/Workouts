//
//  ExerciseImageView.swift
//  WorkoutsSnapshotTests
//
//  Created by Mauricio Figueroa on 14-11-23.
//

import Foundation
import XCTest
import SnapshotTesting
@testable import Workouts

final class ExerciseImageViewTests: XCTestCase {
    func test_view_looksGood() {
        let view = ExerciseImageView(
            viewModel: .init(exerciseImage: ExerciseImage(id: 1, isMain: true, image: ""))
        )

        assertSnapshots(of: view, as: [.image(layout: .fixed(width: 220, height: 270))])
    }
}
