//
//  APIDispatcher.swift
//  YahooInterview
//
//  Created by Bryan Caragay on 4/14/25.
//

import Foundation

class APIDispatcher {
    func dispatchRequest(request: Request) async throws -> Data? {
        guard let url = URL(string: request.path) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.cannotParseResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return data
    }
}

