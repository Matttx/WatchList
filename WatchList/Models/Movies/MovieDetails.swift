//
//  MovieDetails.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 16/11/2023.
//

import Foundation

// MARK: - MovieDetails
struct MovieDetails: Codable {
    
    let adult: Bool?
    let backdropPath: String?
    let genres: [Genre]?
    let id: Int?
    let overview: String?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let runtime: Int?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let credits: Credits?
    let similarMovies: [Movies.Movie]?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genres, id
        case overview
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case runtime, tagline, status, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case credits, similarMovies
    }
    
    // MARK: - Genre
    struct Genre: Codable {
        let id: Int?
        let name: String?
    }

    // MARK: - ProductionCompany
    struct ProductionCompany: Codable {
        let id: Int?
        let name: String?
    }

    // MARK: - ProductionCountry
    struct ProductionCountry: Codable {
        let name: String?

        enum CodingKeys: String, CodingKey {
            case name
        }
    }
    
    static func fetchDetails(_ id: Int) async throws -> MovieDetails {
        do {
            let details: MovieDetails = try await APIManager.shared.task(url: "/movie/\(id)", queries: ["language" : "fr"])
            let credits = try await Credits.fetchCredits(movie: id)
            let similarMovies = try await Movies.fetchSimilar(id)
            
            return update(details, credits, similarMovies)
        } catch {
            print("Error fetchDetails: \(error)")
            throw error
        }
    }
    
    static private func update(_ details: MovieDetails, _ credits: Credits, _ similarMovies: [Movies.Movie]) -> MovieDetails {
        return .init(adult: details.adult,
                     backdropPath: "https://image.tmdb.org/t/p/original\(details.backdropPath ?? "")",
                     genres: details.genres,
                     id: details.id,
                     overview: details.overview,
                     posterPath: "https://image.tmdb.org/t/p/original\(details.posterPath ?? "")",
                     productionCompanies: details.productionCompanies,
                     productionCountries: details.productionCountries,
                     releaseDate: details.releaseDate?.formatDate(from: "yyyy-MM-dd", to: "dd/MM/yyyy"),
                     runtime: details.runtime,
                     status: details.status,
                     tagline: details.tagline,
                     title: details.title,
                     video: details.video,
                     voteAverage: details.voteAverage,
                     voteCount: details.voteCount,
                     credits: credits,
                     similarMovies: similarMovies
        )
    }
}

// MARK: - Store

@MainActor
class MovieDetailsStore: ObservableObject {
    @Published var details: MovieDetails?
    
    enum Phase {
        case loading, success, failure
    }
    
    @Published var phase: Phase?
    @Published var error: Error?
    
    func fetchDetails(_ id: Int) async {
        do {
            phase = .loading
            details = try await MovieDetails.fetchDetails(id)
            phase = .success
        } catch {
            phase = .failure
            self.error = error
        }
    }
}
