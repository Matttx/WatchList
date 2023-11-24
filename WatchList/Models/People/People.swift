//
//  People.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 20/11/2023.
//

import Foundation

// MARK: - People
struct People: Codable {
    let adult: Bool?
    let biography, birthday: String?
    let deathday: String?
    let birthPlace: String?
    let gender: Int?
    let id: Int?
    let knownForDepartment, name: String?
    let profilePath: String?
    let cast: [Cast]?
    
    var birthAndDeathLabel: String? {
        guard let birth = birthday else { return nil }
        
        let deathday = deathday
        
        return "\(birth)\(deathday != nil ? " - \(deathday!)" : "")"
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case biography, birthday, deathday, gender, id
        case birthPlace = "place_of_birth"
        case knownForDepartment = "known_for_department"
        case name
        case profilePath = "profile_path"
        case cast
    }
    
    struct Cast: MediaProtocol {
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
            case type = "media_type"
        }
    }
    
    static func fetchDetails(_ id: Int) async throws -> People {
        do {
            let people: People = try await APIManager.shared.task(url: "/person/\(id)", queries: ["language": "fr"])
            let medias: People = try await APIManager.shared.task(url: "/person/\(id)/combined_credits", queries: ["language": "fr"])
            
            return update(people, medias.cast)
        } catch {
            print("Error fetchDetails: \(error)")
            throw error
        }
    }
    
    static private func update(_ people: People, _ cast: [Cast]? = nil) -> People {
        return .init(adult: people.adult,
                     biography: people.biography,
                     birthday: people.birthday?.formatDate(from: "yyyy-MM-dd", to: "dd MMM yyyy"),
                     deathday: people.deathday?.formatDate(from: "yyyy-MM-dd", to: "dd MMM yyyy"),
                     birthPlace: people.birthPlace,
                     gender: people.gender,
                     id: people.id,
                     knownForDepartment: people.knownForDepartment,
                     name: people.name,
                     profilePath: "https://image.tmdb.org/t/p/original\(people.profilePath ?? "")",
                     cast: cast?.compactMap {
            .init(id: $0.id,
                  adult: $0.adult,
                  title: $0.title,
                  poster: "https://image.tmdb.org/t/p/w500\($0.poster ?? "")",
                  backdrop: "https://image.tmdb.org/t/p/original\($0.backdrop ?? "")",
                  ratingAverage: $0.ratingAverage,
                  ratingCount: $0.ratingCount,
                  date: $0.date?.formatDate(from: "yyyy-MM-dd", to: "dd/MM/yyyy"),
                  popularity: $0.popularity,
                  type: $0.type)
        }
            .sorted { $0.popularity ?? 0 > $1.popularity ?? 0}
            .filter { $0.adult == false }
        )
    }
}

// MARK: - Store

@MainActor
class PeopleStore: ObservableObject {
    @Published var details: People?
    
    enum Phase {
        case loading, success, failure
    }
    
    @Published var phase: Phase?
    @Published var error: Error?
    
    func fetchDetails(_ id: Int) async {
        do {
            phase = .loading
            details = try await People.fetchDetails(id)
            phase = .success
        } catch {
            phase = .failure
            self.error = error
        }
    }
}
