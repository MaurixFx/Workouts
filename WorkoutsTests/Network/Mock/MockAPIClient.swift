//
//  MockAPIClient.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 10-11-23.
//

import Foundation
@testable import Workouts

final class MockAPIClient: HTTPClient {
    private(set) var getCallsCount = 0
    private(set) var getWasCalled = false
    var getResult: Result<Any, APIError>?

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
