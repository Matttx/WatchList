//
//  Date+Extensions.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 16/11/2023.
//

import Foundation

extension Date {
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        return "\(components.year ?? 0)"
    }
}
