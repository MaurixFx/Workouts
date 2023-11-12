//
//  MockExerciseManager.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 11-11-23.
//

import Foundation
@testable import Workouts

final class MockExerciseManager: ExerciseService {
    private(set) var fetchWasCalled = false
    private(set) var fetchCallsCount = 0
    var fetchResult: Result<[Exercise], Error>?

    func fetch() async throws -> [Exercise] {
        fetchWasCalled = true
        fetchCallsCount += 1
        
        return try await withCheckedThrowingContinuation { continuation in
            guard let fetchResult else {
                continuation.resume(throwing: APIError.invalidResponse)
                return
            }
            
            switch fetchResult {
            case .failure(let error):
                continuation.resume(throwing: error)
            case .success(let exercises):
                continuation.resume(returning: exercises)
            }
        }
    }
    
    func fetchVariations(for variationIDs: [Int]) async throws -> [Exercise] {
        return []
    }
}
