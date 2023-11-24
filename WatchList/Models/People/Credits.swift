//
//  Credits.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 20/11/2023.
//

import Foundation

// MARK: - Credits
struct Credits: Codable {
    let id: Int?
    let cast, crew: [Cast]?
    
    // MARK: - Cast
    struct Cast: Codable {
        let adult: Bool?
        let gender, id: Int?
        let knownForDepartment: String?
        let name, originalName: String?
        let popularity: Double?
        let profilePath: String?
        let castID: Int?
        let character, creditID: String?
        let order: Int?
        let department: String?
        let job: String?

        enum CodingKeys: String, CodingKey {
            case adult, gender, id
            case knownForDepartment = "known_for_department"
            case name
            case originalName = "original_name"
            case popularity
            case profilePath = "profile_path"
            case castID = "cast_id"
            case character
            case creditID = "credit_id"
            case order, department, job
        }
    }
    
    var director: Cast? {
        return crew?.first{$0.job == "Director"} ?? nil
    }
    
    static func fetchCredits(movie: Int) async throws -> Credits {
        do {
            let data: Credits = try await APIManager.shared.task(url: "/movie/\(movie)/credits", queries: ["language" : "fr"])
            
            return update(data)
        } catch {
            print("Error fetchCredits: \(error)")
            throw error
        }
    }
    
    static func fetchCredits(serie: Int) async throws -> Credits {
        do {
            let data: Credits = try await APIManager.shared.task(url: "/tv/\(serie)/credits", queries: ["language" : "fr"])
            
            return update(data)
        } catch {
            print("Error fetchCredits: \(error)")
            throw error
        }
    }
    
    static private func update(_ credits: Credits) -> Credits {
        let cast: [Cast] = credits.cast?.compactMap {
            .init(adult: $0.adult,
                  gender: $0.gender,
                  id: $0.id,
                  knownForDepartment: $0.knownForDepartment,
                  name: $0.name,
                  originalName: $0.originalName,
                  popularity: $0.popularity,
                  profilePath: "https://image.tmdb.org/t/p/original\($0.profilePath ?? "")",
                  castID: $0.castID,
                  character: $0.character,
                  creditID: $0.creditID,
                  order: $0.order,
                  department: $0.department,
                  job: $0.job)
        } ?? []
        
        let crew: [Cast] = credits.crew?.compactMap {
            .init(adult: $0.adult,
                  gender: $0.gender,
                  id: $0.id,
                  knownForDepartment: $0.knownForDepartment,
                  name: $0.name,
                  originalName: $0.originalName,
                  popularity: $0.popularity,
                  profilePath: "https://image.tmdb.org/t/p/original\($0.profilePath ?? "")",
                  castID: $0.castID,
                  character: $0.character,
                  creditID: $0.creditID,
                  order: $0.order,
                  department: $0.department,
                  job: $0.job)
        } ?? []
        
        return .init(id: credits.id,
                     cast: cast,
                     crew: crew)
    }
}

// MARK: - Store

@MainActor
class CreditsStore: ObservableObject {
    @Published var credits: Credits?
    
    enum Phase {
        case loading, success, failure
    }
    
    @Published var phase: Phase?
    @Published var error: Error?
    
    func fetchCredits(movie: Int) async {
        do {
            phase = .loading
            credits = try await Credits.fetchCredits(movie: movie)
            phase = .success
        } catch {
            phase = .failure
            self.error = error
        }
    }
}
