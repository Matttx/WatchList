//
//  String+Extensions.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 19/11/2023.
//

import Foundation

extension String {
    
    func formatDate(from inputFormat: String?, to outputFormat: String) -> String? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat

        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = outputFormat
            dateFormatter.locale = Locale(identifier: "fr-FR")
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    func toDate(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        if let date = dateFormatter.date(from: self) {
            return date
        }
        
        return Date.now
    }
}
