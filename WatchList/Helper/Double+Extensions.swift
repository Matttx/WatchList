//
//  Double+Extensions.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 19/11/2023.
//

import Foundation

extension Double {
    func round(decimals: Int) -> String {
        return String(format: "%.\(decimals)f", self)
    }
}
