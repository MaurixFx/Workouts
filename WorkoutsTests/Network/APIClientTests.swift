//
//  APIClientTests.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 10-11-23.
//

import Foundation
import XCTest
@testable import Workouts

final class APIClientTests: XCTestCase {
    func test_get_performsGETRequestWithURL() async {
        let expectation = expectation(description: "API Request")
        let url = URL(string: "https://www.fakeurl.com")!

        MockURLProtocol.loadingHandler = { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")

            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            expectation.fulfill()

            return (response, Data())
        }

        let sut = makeSUT()

        _ = try? await sut.get(url.absoluteString, responseType: Exercise.self)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_failsOnInvalidRequestError() async {
        let expectedError = APIError.invalidResponse
        let expectation = expectation(description: "API Request")
        let url = URL(string: "https://www.fakeurl.com")!

        MockURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }

        let sut = makeSUT()

        do {
            _ = try await sut.get(url.absoluteString, responseType: Exercise.self)
            XCTFail("The request should have failed in a invalid HTTPURLResponse")
        } catch  {
            XCTAssertEqual(error as? APIError, expectedError)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_failsOnAValidHTTPURLResponse_andInvalidData() async {
        let expectedError = APIError.decodingError
        let expectation = expectation(description: "API Request")
        let url = URL(string: "https://www.fakeurl.com")!

        MockURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }

        let sut = makeSUT()

        do {
            _ = try await sut.get(url.absoluteString, responseType: Exercise.self)
            XCTFail("The request should have failed in a valid HTTPURLResponse and invalid Data")
        } catch  {
            XCTAssertEqual(error as? APIError, expectedError)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_succeedsOnAValidHTTPURLResponse_andValidData() async {
        let expectation = expectation(description: "API Request")
        let url = URL(string: "https://www.fakeurl.com")!
        let jsonString = """
                         {
                             "results": [
                                 {
                                     "id": 4,
                                     "name": "Abs Abs",
                                     "description": "bla bla bla bla",
                                     "images": [],
                                     "variations": []
                                 }
                             ]
                         }
                         """
        
        let data = jsonString.data(using: .utf8)

        MockURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        let sut = makeSUT()

        do {
            let response = try await sut.get(url.absoluteString, responseType: ExerciseResponse.self)
            XCTAssertTrue(!response.results.isEmpty)
            expectation.fulfill()
        } catch  {
            XCTFail("The request should have not failed in a valid HTTPURLResponse and valid Data")
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> APIClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)

        let sut = APIClient(session: session)
        
        return sut
    }
    
    enum APIError: Error {
        case invalidURL
        case invalidResponse
        case decodingError
    }

    private class APIClient {
        private let session: URLSession

        init(session: URLSession = .shared) {
            self.session = session
        }

        func get<T: Decodable>(_ url: String, responseType: T.Type) async throws -> T {
            guard let url = URL(string: url) else {
                throw APIError.invalidURL
            }

            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decodingError
            }
        }
    }
}
