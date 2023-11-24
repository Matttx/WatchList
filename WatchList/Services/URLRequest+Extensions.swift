//
//  URLRequest+Extensions.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 15/11/2023.
//

import Foundation

fileprivate let API_KEY = "YOUR TMBD API KEY"

fileprivate let BASE_URL = "https://api.themoviedb.org/3"

extension URLRequest {
    enum HTTPMethod: String {
        case get, post, put, delete
    }

    init?(path: String,
          queries: [String: String] = [:],
          httpMethod: HTTPMethod,
          header: [String: String] = [:],
          body: Data?
    ) {
                
        guard var components = URLComponents(string: "\(BASE_URL)\(path)") else {
            return nil
        }
        
        if !queries.isEmpty {
            components.queryItems = queries.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
        }
        
        guard let url = components.url else {
            return nil
        }
        
        self.init(url: url)
        self.httpMethod = httpMethod.rawValue.uppercased()
        self.allHTTPHeaderFields = header
        
        self.timeoutInterval = 10
        
        let httpHeader = [
            "accept": "application/json",
            "Authorization": "Bearer \(API_KEY)"
        ]
        
        self.allHTTPHeaderFields = httpHeader
        
        guard httpMethod == .post else {
            return
        }
        
        self.httpBody = body
    }
}
