//
//  ExerciseManager.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 10-11-23.
//

import Foundation

protocol ExerciseService {
    func fetch() async throws -> [Exercise]
    func fetchVariations(for variationIDs: [Int]) async throws -> [Exercise]
}

final class ExerciseManager: ExerciseService {
    private let client: HTTPClient

    // MARK: - Init

    init(client: HTTPClient = APIClient()) {
        self.client = client
    }
    
    // MARK: - Fetch
    
    func fetch() async throws -> [Exercise] {
        let response = try await client.get(ExerciseAPIEndpoint.url, responseType: ExerciseResponse.self)
        return response.results
    }
    
    // MARK: - Fetch variations

    func fetchVariations(for variationIDs: [Int]) async throws -> [Exercise] {
        var exercises = [Exercise]()

        try await withThrowingTaskGroup(of: (Exercise?, Error?).self) { group in
            for id in variationIDs {
                group.addTask {
                    do {
                        let exercise = try await self.client.get(ExerciseDetailAPIEndpoint.url(with: id), responseType: Exercise.self)
                        return (exercise, nil)
                    } catch {
                        return (nil, error)
                    }
                }

                for try await result in group {
                    if let exercise = result.0 {
                        exercises.append(exercise)
                    } else if let error = result.1 {
                        throw error
                    }
                }

            }
        }

        return exercises
    }
}
