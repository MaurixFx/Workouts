//
//  ExerciseManager.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 10-11-23.
//

import Foundation

final class ExerciseManager {
    private let client: HTTPClient

    // MARK: - Init

    init(client: HTTPClient = APIClient()) {
        self.client = client
    }
    
    func fetch() async throws -> [Exercise] {
        let response = try await client.get("http://www.fakeURL.com", responseType: ExerciseResponse.self)
        return response.results
    }
}
