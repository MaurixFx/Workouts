//
//  ExerciseItemViewModel.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
import XCTest
@testable import Workouts

final class ExerciseItemViewModelTests: XCTestCase {
    func test_mainExerciseImageURL_returnsExpectedValue() {
        let sut = ExerciseItemViewModel(name: "abs abs", mainExerciseImage: ExerciseImage(id: 1, isMain: true, image: "http://www.fakeurl.com"))
        
        XCTAssertEqual(sut.mainExerciseImageURL, URL(string: "http://www.fakeurl.com"), "mainExerciseImageURL should have returned the expected URL")
    }
}
