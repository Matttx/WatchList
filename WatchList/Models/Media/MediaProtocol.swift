//
//  Cast.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 22/11/2023.
//

import Foundation

protocol MediaProtocol: Identifiable, Codable, Hashable {
    var id: Int? { get set }
    var adult: Bool? { get set }
    var title: String? { get set }
    var poster: String? { get set }
    var backdrop: String? { get set }
    var ratingAverage: Double? { get set }
    var ratingCount: Int? { get set }
    var date: String? { get set }
    var popularity: Double? { get set }
    var type: String? { get set }
}
