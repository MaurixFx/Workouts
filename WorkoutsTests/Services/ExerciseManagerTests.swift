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
    
    // MARK: - Fetch

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
    
    // MARK: - Fetch Variations
    
    func test_fetchVariations_callsAPIClient() async {
        let (sut, client) = makeSUT()
        client.getResult = .success(anyExerciseResponse.results.first!)

        _ = try? await sut.fetchVariations(for: [2,3])

        XCTAssertTrue(client.getWasCalled, "get method on MockAPIClient should get called")
        XCTAssertEqual(client.getCallsCount, 2, "get method on MockAPIClient should get called the expected times depending on the number of variations")
    }
    
    func test_fetchVariations_throwsAnError_whenAPIClientFails() async {
        let expectedError = APIError.invalidResponse
        let (sut, client) = makeSUT()
        client.getResult = .failure(expectedError)

        do {
            _ = try await sut.fetchVariations(for: [2,3])
            XCTFail("fetch operation should have not succeed")
        } catch {
            XCTAssertEqual(error as? APIError, expectedError, "The error coming from the fetch variations operation should be same that the expected error")
        }
    }
    
    func test_fetchVariations_returnsAnExerciseList_whenAPIClientSucceeds() async {
        let (sut, client) = makeSUT()
        client.getResult = .success(anyExerciseResponse.results.first!)

        do {
            let receivedExerciseList = try await sut.fetchVariations(for: [2])
            XCTAssertEqual(receivedExerciseList, anyExerciseResponse.results, "receivedExerciseList should the same that the expected exercise list")
        } catch {
            XCTFail("fetch operation should have not failed, it got instead an \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ExerciseManager, client: MockAPIClient) {
        let client = MockAPIClient()
        let sut = ExerciseManager(client: client)
        
        return (sut, client)
    }
}
