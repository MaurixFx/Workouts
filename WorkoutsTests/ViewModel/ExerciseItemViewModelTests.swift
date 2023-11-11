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
    func test_mainImageURL_returnsAnURL_whenMainImageExists() {
        let sut = ExerciseItemViewModel(name: "abs abs", images: [
            ExerciseImage(id: 1, isMain: true, image: "http://www.fakeurl.com")
        ])
        
        XCTAssertEqual(sut.mainImageURL, URL(string: "http://www.fakeurl.com"), "mainImageURL should have returned the expected URL")
    }
}
