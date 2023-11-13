//
//  ExerciseTests.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 13-11-23.
//

import Foundation
import XCTest
@testable import Workouts

final class ExerciseTests: XCTestCase {
    func test_mainExerciseImage_returnsNil_whenImagesArrayIsEmpty() {
        let sut = Exercise(id: 1, name: "Jump", description: "", images: [], variations: [])
        
        XCTAssertNil(sut.mainExerciseImage, "mainExerciseImage should have returned nil when exercise does not have a images array list")
    }
    
    func test_mainExerciseImage_returnsNil_whenMainImageDoesNotExist() {
        let sut = Exercise(id: 1, name: "Jump", description: "", images: [
            ExerciseImage(id: 1, isMain: false, image: "http://www.fakeurl.com")
        ], variations: [])
        
        XCTAssertNil(sut.mainExerciseImage, "mainExerciseImage should have returned nil when Exercise does not have a main image")
    }
    
    func test_mainExerciseImage_returnsExerciseImage_whenMainImageExists() {
        let expectedValue = ExerciseImage(id: 1, isMain: true, image: "http://www.fakeurl.com")
        
        let sut = Exercise(id: 1, name: "Jump", description: "", images: [
            ExerciseImage(id: 1, isMain: true, image: "http://www.fakeurl.com")
        ], variations: [])
        
        XCTAssertEqual(sut.mainExerciseImage, expectedValue, "mainExerciseImage should have returned the expected ExerciseImage value")
    }
}
