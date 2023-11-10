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

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)

        let sut = APIClient(session: session)

        _ = try? await sut.get(url.absoluteString, responseType: Exercise.self)

        wait(for: [expectation], timeout: 1.0)
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
