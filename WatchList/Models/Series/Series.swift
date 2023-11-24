//
//  Series.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 22/11/2023.
//

import Foundation

struct Series: Codable {
    var results: [Serie]
    
    struct Serie: MediaProtocol {
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
            case title = "name"
            case poster = "poster_path"
            case backdrop = "backdrop_path"
            case ratingAverage = "vote_average"
            case ratingCount = "vote_count"
            case date = "first_air_date"
            case popularity
            case type
        }
    }
    
    static func fetchOnAir() async throws -> [Serie] {
        do {
            let data: Series = try await APIManager.shared.task(url: "/tv/on_the_air", queries: [
                "language": "fr",
                "page": "1"
            ])
            
            return update(data)
        } catch {
            print("Error fetchOnAir: \(error)")
            throw error
        }
    }
    
    static func fetchPopular() async throws -> [Serie] {
        do {
            let data: Series = try await APIManager.shared.task(url: "/tv/popular", queries: [
                "language": "fr",
                "page": "1"
            ])
            
            return update(data)
        } catch {
            print("Error fetchPopular: \(error)")
            throw error
        }
    }
    
    static func fetchTopRated() async throws -> [Serie] {
        do {
            let data: Series = try await APIManager.shared.task(url: "/tv/top_rated", queries: [
                "language": "fr",
                "page": "1"
            ])
            
            return update(data)
        } catch {
            print("Error fetchTopRated: \(error)")
            throw error
        }
    }
    
    static func fetchSimilar(_ id: Int) async throws -> [Serie] {
        do {
            let data: Series = try await APIManager.shared.task(url: "/tv/\(id)/similar", queries: [
                "language": "fr",
                "page": "1"
            ])
            
            return update(data)
        } catch {
            print("Error fetchSimilar: \(error)")
            throw error
        }
    }
    
    static private func update(_ data: Series) -> [Serie] {
        return data.results.map {
            .init(id: $0.id,
                  adult: $0.adult,
                  title: $0.title,
                  poster: "https://image.tmdb.org/t/p/w500\($0.poster ?? "")",
                  backdrop: $0.backdrop,
                  ratingAverage: $0.ratingAverage,
                  ratingCount: $0.ratingCount,
                  date: $0.date?.formatDate(from: "yyyy-MM-dd", to: "dd/MM/yyyy"),
                  popularity: $0.popularity,
                  type: "tv")
        }
        .sorted { $0.popularity ?? 0 > $1.popularity ?? 0 }
        .filter { $0.adult == false }
    }
}

// MARK: - Store

@MainActor
class SeriesStore: ObservableObject {
    @Published var onAir: [Series.Serie] = []
    @Published var popular: [Series.Serie] = []
    @Published var topRated: [Series.Serie] = []
    
    var all: [Series.Serie] {
        return (onAir + popular + topRated).removeDuplicates()
    }
    
    enum Phase {
        case loading, success, failure
    }
    
    @Published var phase: Phase?
    @Published var error: Error?
    
    func fetchAllSeries() async {
        do {
            phase = .loading
            if onAir.isEmpty {
                onAir = try await Series.fetchOnAir()
            }
            
            if popular.isEmpty {
                popular = try await Series.fetchPopular()
            }
            
            if topRated.isEmpty {
                topRated = try await Series.fetchTopRated().removeCommonElements(with: onAir)
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
            onAir = try await Series.fetchOnAir()
            popular = try await Series.fetchPopular()
            topRated = try await Series.fetchTopRated()
            phase = .success
        } catch {
            phase = .failure
            self.error = error
        }
    }
}
