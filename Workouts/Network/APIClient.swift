//
//  APIClient.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 10-11-23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

final class APIClient {
    private let session: URLSession
    
    // MARK: - Init

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
