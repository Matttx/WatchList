//
//  Error.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 14/11/2023.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    
    case badRequest
    
    case serverError
    
    case notFound
    
    case invalidData
    
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL was invalid. Please try again later."
        case .badRequest:
            return "The sending request failed. Please try again later."
        case .serverError:
            return "There was an error with the server. Please try again later."
        case .notFound:
            return "The given URL was not found. Please try again later."
        case .invalidData:
            return "The data is invalid. Please try again later."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
