//
//  ExerciseManager.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 10-11-23.
//

import Foundation

protocol ExerciseService {
    func fetch() async throws -> [Exercise]
}

final class ExerciseManager: ExerciseService {
    private let client: HTTPClient

    // MARK: - Init

    init(client: HTTPClient = APIClient()) {
        self.client = client
    }
    
    func fetch() async throws -> [Exercise] {
        let response = try await client.get(ExerciseAPIEndpoint.url, responseType: ExerciseResponse.self)
        return response.results
    }
}
