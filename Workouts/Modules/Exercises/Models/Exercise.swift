//
//  Exercise.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 10-11-23.
//

import Foundation

struct ExerciseResponse: Codable {
    let results: [Exercise]
}

struct Exercise: Codable, Equatable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let description: String
    let images: [ExerciseImage]?
    let variations: [Int]?
}

struct ExerciseImage: Codable {
    let id: Int
    let isMain: Bool
    let image: String
}
