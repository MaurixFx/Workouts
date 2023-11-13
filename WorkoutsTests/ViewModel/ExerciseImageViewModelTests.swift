//
//  ExerciseImageViewModelTests.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 13-11-23.
//

import Foundation
import XCTest
@testable import Workouts

final class ExerciseImageViewModelTests: XCTestCase {
    func test_exerciseImageURL_returnsExpectedValue() {
        let exerciseImage = ExerciseImage(id: 1, isMain: true, image: "http://www.fakeurl.com")
        let sut = ExerciseImageViewModel(exerciseImage: exerciseImage)
        
        XCTAssertEqual(sut.exerciseImageURL, URL(string: "http://www.fakeurl.com"), "exerciseImageURL should have returned the expected URL")
    }
    
    func test_exerciseImageURL_returnsNil_whenURLIsNotValid() {
        let exerciseImage = ExerciseImage(id: 1, isMain: true, image: "")
        let sut = ExerciseImageViewModel(exerciseImage: exerciseImage)
        
        XCTAssertNil(sut.exerciseImageURL, "exerciseImageURL should have returned nil when URL is not valid")
    }
}
