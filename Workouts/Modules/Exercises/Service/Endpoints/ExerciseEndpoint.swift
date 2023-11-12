//
//  ExerciseEndpoint.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation

enum ExerciseAPIEndpoint {
    static let url = "https://wger.de/api/v2/exerciseinfo/"
}

enum ExerciseDetailAPIEndpoint {
    static func url(with id: Int) -> String {
        "https://wger.de/api/v2/exerciseinfo/\(id)"
    }
}
