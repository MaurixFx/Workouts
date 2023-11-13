//
//  XCTest-share-extension.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 13-11-23.
//

import Foundation
import XCTest
@testable import Workouts

extension XCTestCase {
    var anyExerciseResponse: ExerciseResponse {
        .init(results: [
            Exercise(id: 4,
                     name: "Abs Abs",
                     description: "bla bla bla bla",
                     images: [],
                     variations: []
                    )
        ])
    }
}
