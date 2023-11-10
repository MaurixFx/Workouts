//
//  Exercise.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 10-11-23.
//

import Foundation

struct Exercise: Codable {
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
