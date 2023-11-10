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
    
    func test_fetch_throwsAnError_whenAPIClientFails() async {
        let client = MockAPIClient()
        let expectedError = APIError.invalidResponse
        let sut = ExerciseManager(client: client)
        client.getResult = .failure(expectedError)
        
        do {
            try await sut.fetch()
        } catch {
            XCTAssertEqual(error as? APIError, expectedError, "The error coming from the fetch operation should be same that our expected error")
        }
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
        var getResult: Result<ExerciseResponse, APIError>?

        func get<T>(_ url: String, responseType: T.Type) async throws -> T where T : Decodable {
            getWasCalled = true
            getCallsCount += 1
            
            let mockValue: T = try await withCheckedThrowingContinuation { continuation in
                
                guard let getResult else {
                    continuation.resume(throwing: APIError.decodingError)
                    return
                }
                
                switch getResult {
                case .failure(let expectedError):
                    continuation.resume(throwing: expectedError)
                default:
                    break
                }
            }
            
            return mockValue
        }
    }
}
