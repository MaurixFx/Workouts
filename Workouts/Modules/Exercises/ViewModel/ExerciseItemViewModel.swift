//
//  S.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation

struct ExerciseItemViewModel: Equatable {
    static func == (lhs: ExerciseItemViewModel, rhs: ExerciseItemViewModel) -> Bool {
        lhs.name == rhs.name
    }
    
    let name: String
    let images: [ExerciseImage]?
    
    /// Returns imageURL for the image where the property isMain is true
    var mainImageURL: URL? {
        guard let images else { return nil }
        
        return URL(string: images.first(where: { $0.isMain })?.image ?? "")
    }
}
