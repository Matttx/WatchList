//
//  Movies.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 15/11/2023.
//

import Foundation

struct Movies: Codable {
    var results: [Movie]
    
    struct Movie: MediaProtocol {
        var id: Int?
        var adult: Bool?
        var title: String?
        var poster: String?
        var backdrop: String?
        var ratingAverage: Double?
        var ratingCount: Int?
        var date: String?
        var popularity: Double?
        var type: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case adult
            case title
            case poster = "poster_path"
            case backdrop = "backdrop_path"
            case ratingAverage = "vote_average"
            case ratingCount = "vote_count"
            case date = "release_date"
            case popularity
            case type
        }
    }
    
    static func fetchNowPlaying() async throws -> [Movie] {
        do {
            let data: Movies = try await APIManager.shared.task(url: "/movie/now_playing", queries: [
                "language": "fr",
                "page": "1"
            ])
                                  
            return update(data)
        } catch {
            print("Error fetchNowPlaying: \(error)")
            throw error
        }
    }
    
    static func fetchPopular() async throws -> [Movie] {
        do {
            let data: Movies = try await APIManager.shared.task(url: "/movie/popular", queries: [
                "language": "fr",
                "page": "1"
            ])
            
            return update(data)
        } catch {
            print("Error fetchPopular: \(error)")
            throw error
        }
    }
    
    static func fetchTopRated() async throws -> [Movie] {
        do {
            let data: Movies = try await APIManager.shared.task(url: "/movie/top_rated", queries: [
                "language": "fr",
                "page": "1"
            ])
            
            return update(data)
        } catch {
            print("Error fetchTopRated: \(error)")
            throw error
        }
    }
    
    static func fetchSimilar(_ id: Int) async throws -> [Movie] {
        do {
            let data: Movies = try await APIManager.shared.task(url: "/movie/\(id)/similar", queries: [
                "language": "fr",
                "page": "1"
            ])
            
            return update(data)
        } catch {
            print("Error fetchSimilar: \(error)")
            throw error
        }
    }
    
    static private func update(_ data: Movies) -> [Movie] {
        return data.results.map {
            .init(id: $0.id,
                  adult: $0.adult,
                  title: $0.title,
                  poster: "https://image.tmdb.org/t/p/w500\($0.poster ?? "")",
                  ratingAverage: $0.ratingAverage,
                  ratingCount: $0.ratingCount,
                  date: $0.date?.formatDate(from: "yyyy-MM-dd", to: "dd/MM/yyyy"),
                  popularity: $0.popularity,
                  type: "movie")
        }
        .sorted { $0.popularity ?? 0 > $1.popularity ?? 0 }
        .filter { $0.adult == false }
    }
}

// MARK: - Preview Data

extension Movies.Movie {
    static let preview: Movies.Movie = .init(
        id: 1, title: "Five Night At Freddy's", poster: "fake.png", ratingAverage: 9.30, ratingCount: 3450, date: "2023-10-12", type: "movie"
    )
}

extension Movies {
    static let preview: [Movie] = [
        Movie.preview,
        Movie.preview,
        Movie.preview
    ]
}


// MARK: - Store

@MainActor
class MoviesStore: ObservableObject {
    @Published var nowPlaying: [Movies.Movie] = []
    @Published var popular: [Movies.Movie] = []
    @Published var topRated: [Movies.Movie] = []
    
    var all: [Movies.Movie] {
        return (nowPlaying + popular + topRated).removeDuplicates()
    }
    
    enum Phase {
        case loading, success, failure
    }
    
    @Published var phase: Phase?
    @Published var error: Error?
    
    func fetchAllMovies() async {
        do {
            phase = .loading
            if nowPlaying.isEmpty {
                nowPlaying = try await Movies.fetchNowPlaying()
            }
            
            if popular.isEmpty {
                popular = try await Movies.fetchPopular().removeCommonElements(with: nowPlaying)
            }
            
            if topRated.isEmpty {
                topRated = try await Movies.fetchTopRated().removeCommonElements(with: nowPlaying)
            }
            phase = .success
        } catch {
            phase = .failure
            self.error = error
        }
    }
    
    func refreshView() async {
        do {
            phase = .loading
            nowPlaying = try await Movies.fetchNowPlaying()
            popular = try await Movies.fetchPopular()
            topRated = try await Movies.fetchTopRated()
            phase = .success
        } catch {
            phase = .failure
            self.error = error
        }
    }
}
