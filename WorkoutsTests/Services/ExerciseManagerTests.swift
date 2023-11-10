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
        let (sut, client) = makeSUT()
        
        _ = try? await sut.fetch()
        
        XCTAssertTrue(client.getWasCalled, "get method on MockAPIClient should get called")
        XCTAssertEqual(client.getCallsCount, 1, "get method on MockAPIClient should get called just once")
    }
    
    func test_fetch_throwsAnError_whenAPIClientFails() async {
        let expectedError = APIError.invalidResponse
        let (sut, client) = makeSUT()
        client.getResult = .failure(expectedError)
        
        do {
            _ = try await sut.fetch()
        } catch {
            XCTAssertEqual(error as? APIError, expectedError, "The error coming from the fetch operation should be same that our expected error")
        }
    }
    
    func test_fetch_returnsAnExerciseList_whenAPIClientSucceeds() async {
        let (sut, client) = makeSUT()
        client.getResult = .success(anyExerciseResponse)
        
        do {
            let receivedExerciseList = try await sut.fetch()
            XCTAssertEqual(receivedExerciseList, anyExerciseResponse.results)
        } catch {
            XCTFail("fetch operation should have not failed, it got instead an \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers

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
    
    private func makeSUT() -> (sut: ExerciseManager, client: MockAPIClient) {
        let client = MockAPIClient()
        let sut = ExerciseManager(client: client)
        
        return (sut, client)
    }
    
    private class ExerciseManager {
        private let client: HTTPClient

        init(client: HTTPClient = APIClient()) {
            self.client = client
        }
        
        func fetch() async throws -> [Exercise] {
            let response = try await client.get("http://www.fakeURL.com", responseType: ExerciseResponse.self)
            return response.results
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
                case .success(let expectedResponse):
                    do {
                        if let expectedGenericValue = expectedResponse as? T {
                            continuation.resume(returning: expectedGenericValue)
                        } else {
                            throw APIError.decodingError
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            return mockValue
        }
    }
}
