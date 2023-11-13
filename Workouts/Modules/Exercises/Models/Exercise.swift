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
    
    var mainExerciseImage: ExerciseImage? {
        guard let images = images else { return nil }
        
        return images.first(where: { $0.isMain })
    }
}

struct ExerciseImage: Codable, Identifiable {
    let id: Int
    let isMain: Bool
    let image: String
}
