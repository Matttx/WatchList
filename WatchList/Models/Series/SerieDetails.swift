//
//  SerieDetails.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 23/11/2023.
//

import Foundation

struct SerieDetails: Codable {
    let adult: Bool?
    let backdropPath: String?
    let createdBy: [CreatedBy]?
    let firstAirDate: String?
    let genres: [Genre]?
    let id: Int?
    let inProduction: Bool?
    let lastAirDate: String?
    let name: String?
    let numberOfEpisodes, numberOfSeasons: Int?
    let originCountry: [String]?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let seasons: [Season]?
    let status, tagline, type: String?
    let voteAverage: Double?
    let voteCount: Int?
    let credits: Credits?
    let similarSeries: [Series.Serie]?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case firstAirDate = "first_air_date"
        case genres, id
        case inProduction = "in_production"
        case lastAirDate = "last_air_date"
        case name
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons
        case status, tagline, type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case credits, similarSeries
    }
    
    // MARK: - CreatedBy
    struct CreatedBy: Codable {
        let id: Int?
        let creditID, name: String?
        let gender: Int?
        let profilePath: String?

        enum CodingKeys: String, CodingKey {
            case id
            case creditID = "credit_id"
            case name, gender
            case profilePath = "profile_path"
        }
    }

    // MARK: - Genre
    struct Genre: Codable {
        let id: Int?
        let name: String?
    }

    // MARK: - Episode
    struct Episode: Codable {
        let id: Int?
        let name, overview: String?
        let voteAverage: Double?
        let voteCount: Int?
        let airDate: String?
        let episodeNumber: Int?
        let episodeType, productionCode: String?
        let runtime, seasonNumber, showID: Int?
        let stillPath: String?

        enum CodingKeys: String, CodingKey {
            case id, name, overview
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case airDate = "air_date"
            case episodeNumber = "episode_number"
            case episodeType = "episode_type"
            case productionCode = "production_code"
            case runtime
            case seasonNumber = "season_number"
            case showID = "show_id"
            case stillPath = "still_path"
        }
    }
    
    // MARK: - ProductionCompanies
    struct ProductionCompany: Codable {
        let id: Int?
        let name: String?
    }

    // MARK: - ProductionCountry
    struct ProductionCountry: Codable {
        let iso3166_1, name: String?

        enum CodingKeys: String, CodingKey {
            case iso3166_1 = "iso_3166_1"
            case name
        }
    }

    // MARK: - Season
    struct Season: Codable {
        let airDate: String?
        let episodeCount, id: Int?
        let name, overview, posterPath: String?
        let seasonNumber: Int?
        let voteAverage: Double?

        enum CodingKeys: String, CodingKey {
            case airDate = "air_date"
            case episodeCount = "episode_count"
            case id, name, overview
            case posterPath = "poster_path"
            case seasonNumber = "season_number"
            case voteAverage = "vote_average"
        }
    }
    
    static func fetchDetails(_ id: Int) async throws -> SerieDetails {
        do {
            let data: SerieDetails = try await APIManager.shared.task(url: "/tv/\(id)", queries: ["language": "fr"])
            let credits = try await Credits.fetchCredits(serie: id)
            let similarSeries = try await Series.fetchSimilar(id)
            
            return update(data, credits, similarSeries)
        } catch {
            throw error
        }
    }
    
    static private func update(_ details: SerieDetails, _ credits: Credits, _ similarSeries: [Series.Serie]) -> SerieDetails {
        return .init(adult: details.adult,
                     backdropPath: "https://image.tmdb.org/t/p/original\(details.backdropPath ?? "")",
                     createdBy: details.createdBy,
                     firstAirDate: details.firstAirDate?.formatDate(from: "yyyy-MM-dd", to: "dd MMM yyyy"),
                     genres: details.genres,
                     id: details.id,
                     inProduction: details.inProduction,
                     lastAirDate: details.lastAirDate?.formatDate(from: "yyyy-MM-dd", to: "dd MMM yyyy"),
                     name: details.name,
                     numberOfEpisodes: details.numberOfEpisodes,
                     numberOfSeasons: details.numberOfSeasons,
                     originCountry: details.originCountry,
                     overview: details.overview,
                     popularity: details.popularity,
                     posterPath: "https://image.tmdb.org/t/p/original\(details.posterPath ?? "")",
                     productionCompanies: details.productionCompanies,
                     productionCountries: details.productionCountries,
                     seasons: details.seasons?.compactMap {
            if $0.seasonNumber != 0 {
                .init(
                    airDate: $0.airDate,
                    episodeCount: $0.episodeCount,
                    id: $0.id,
                    name: $0.name,
                    overview: $0.overview,
                    posterPath: "https://image.tmdb.org/t/p/original\($0.posterPath ?? "")",
                    seasonNumber: $0.seasonNumber,
                    voteAverage: $0.voteAverage)
            } else { nil }
        }.sorted {$0.seasonNumber ?? 0 < $1.seasonNumber ?? 0},
                     status: details.status,
                     tagline: details.tagline,
                     type: details.type,
                     voteAverage: details.voteAverage,
                     voteCount: details.voteCount,
                     credits: credits,
                     similarSeries: similarSeries)
    }
}

// MARK: - Store

@MainActor
class SerieDetailsStore: ObservableObject {
    @Published var details: SerieDetails?
    
    enum Phase {
        case loading, success, failure
    }
    
    @Published var phase: Phase?
    @Published var error: Error?
    
    func fetchDetails(_ id: Int) async {
        do {
            phase = .loading
            details = try await SerieDetails.fetchDetails(id)
            phase = .success
        } catch {
            phase = .failure
            self.error = error
        }
    }
}
