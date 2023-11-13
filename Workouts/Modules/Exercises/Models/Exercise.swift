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

struct Exercise: Codable, Identifiable, Equatable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let description: String
    let images: [ExerciseImage]?
    let variations: [Int]?
    
    /// Returns the main image of the exercise if exists, otherwise returns nil
    var mainExerciseImage: ExerciseImage? {
        guard let images = images else { return nil }
        
        return images.first(where: { $0.isMain })
    }
}

struct ExerciseImage: Codable, Identifiable, Equatable {
    let id: Int
    let isMain: Bool
    let image: String
    
    static func == (lhs: ExerciseImage, rhs: ExerciseImage) -> Bool {
        lhs.id == rhs.id
    }
}
