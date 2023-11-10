//
//  MockURLProtocol.swift
//  WorkoutsTests
//
//  Created by Mauricio Figueroa on 10-11-23.
//

import Foundation

final class MockURLProtocol: URLProtocol {

    // Handler to test the request and return mock response.
    static var loadingHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.loadingHandler else {
            fatalError("Handler not set.")
        }

        do {
            // Call handler with received request and capture the tuple of response and data.
            let (response, data) = try handler(request)

            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)

            client?.urlProtocolDidFinishLoading(self)

        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
