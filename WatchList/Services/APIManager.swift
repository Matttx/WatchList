//
//  APICallManager.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 14/11/2023.
//

import Foundation


protocol APIManagerProtocol {
    func task<T: Codable>(url: String, method: URLRequest.HTTPMethod, queries: [String: String], body: Data?) async throws -> T?
}

class APIManager: APIManagerProtocol {
    
    static var shared = APIManager()
    
    var header: [String: String] = [:]
    
    private func handleAPIError(urlResponse: URLResponse?) throws {
        guard let response = urlResponse as? HTTPURLResponse else {
            throw APIError.serverError
        }
        
        switch response.statusCode {
        case 400:
            throw APIError.badRequest
        case 404:
            throw APIError.notFound
        default:
            break
        }
    }
    
    func task<T: Codable>(url: String, method: URLRequest.HTTPMethod = .get, queries: [String: String] = [:], body: Data? = nil) async throws -> T {
        
        let json: Data? = body.flatMap({try? JSONEncoder().encode($0)})
        
        guard let request = URLRequest(path: url, queries: queries, httpMethod: method, header: header, body: json) else {
            throw APIError.badRequest
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try handleAPIError(urlResponse: response)
        
        var decodedData: T
        
        do {
            decodedData = try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error: \(error)")
            throw APIError.invalidData
        }
        
        return decodedData
    }
}
