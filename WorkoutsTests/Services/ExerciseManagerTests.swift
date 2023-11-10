//
//  ExerciseManagerTests.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 10-11-23.
//

import Foundation
import XCTest
@testable import Workouts

final class ExerciseManagerTests: XCTestCase {
    func test_fetch_callsAPIClient() async {
        let client = MockAPIClient()
        let sut = ExerciseManager(client: client)
        
        try? await sut.fetch()
        
        XCTAssertTrue(client.getWasCalled, "get method on MockAPIClient should get called")
        XCTAssertEqual(client.getCallsCount, 1, "get method on MockAPIClient should get called just once")
    }
    
    private class ExerciseManager {
        private let client: HTTPClient

        init(client: HTTPClient = APIClient()) {
            self.client = client
        }
        
        func fetch() async throws {
            let response = try? await client.get("TVShowEndpoint.url", responseType: ExerciseResponse.self)
        }
    }
    
    private class MockAPIClient: HTTPClient {
        private(set) var getCallsCount = 0
        private(set) var getWasCalled = false

        func get<T>(_ url: String, responseType: T.Type) async throws -> T where T : Decodable {
            getWasCalled = true
            getCallsCount += 1
            
            let mockValue: T = try await withCheckedThrowingContinuation { continuation in
                do {
                    if let typedValue = anyExerciseResponse as? T {
                        continuation.resume(returning: typedValue)
                    } else {
                        throw APIError.decodingError
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            
            return mockValue
        }
        
        private var anyExerciseResponse: ExerciseResponse {
            .init(results: [
                Exercise(id: 4,
                         name: "Abs Abs",
                         description: "bla bla bla bla",
                         images: [],
                         variations: []
                        )
            ])
        }
    }
}
