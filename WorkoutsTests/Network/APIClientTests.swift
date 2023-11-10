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
        let url = anyFakeURL

        MockURLProtocol.loadingHandler = { request in
            XCTAssertEqual(request.url, url, "URL should be the same")
            XCTAssertEqual(request.httpMethod, "GET", "Http method should be GETs")

            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            expectation.fulfill()

            return (response, Data())
        }

        let sut = makeSUT()

        _ = try? await sut.get(url.absoluteString, responseType: Exercise.self)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_get_failsOnInvalidRequestError() async {
        await checkAPIResponse(for: makeSUT(), statusCode: 400, data: nil, expectedResponse: .failure(APIError.invalidResponse))
    }
    
    func test_get_failsOnAValidHTTPURLResponse_andInvalidData() async {
        await checkAPIResponse(for: makeSUT(), statusCode: 200, data: nil, expectedResponse: .failure(APIError.decodingError))
    }
    
    func test_get_succeedsOnAValidHTTPURLResponse_andValidData() async {
        await checkAPIResponse(for: makeSUT(), statusCode: 200, data: anyValidData, expectedResponse: .success(anyExerciseResponse))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> APIClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)

        let sut = APIClient(session: session)
        
        return sut
    }
    
    private func checkAPIResponse(for sut: APIClient, statusCode: Int, data: Data?, expectedResponse: Result<ExerciseResponse, Error>) async {
        let expectation = expectation(description: "API Request")

        MockURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        let sut = makeSUT()
        
        switch expectedResponse {
        case .success(let expectedResponse):
            let response = try? await sut.get(anyFakeURL.absoluteString, responseType: ExerciseResponse.self)
            XCTAssertEqual(response!.results, expectedResponse.results)
            expectation.fulfill()
        case .failure(let expectedError):
            do {
                let response = try await sut.get(anyFakeURL.absoluteString, responseType: ExerciseResponse.self)
                XCTFail("The request should have failed, instead it got a \(response.results.count) exercise")
            } catch  {
                XCTAssertEqual(error as? APIError, expectedError as? APIClientTests.APIError)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    private var anyFakeURL: URL {
        URL(string: "https://www.fakeurl.com")!
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
    
    private var anyValidData: Data? {
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
        
        return jsonString.data(using: .utf8)
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
