//
//  Array+Extensions.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 20/11/2023.
//

import Foundation

extension Array where Element: Identifiable {
    func removeDuplicates() -> [Element] {
        var uniqueElements: [Element] = []
        var seen: Set<Element.ID> = []
        
        for element in self {
            if !seen.contains(element.id) {
                seen.insert(element.id)
                uniqueElements.append(element)
            }
        }
        
        return uniqueElements
    }
    
    func removeCommonElements(with array2: [Element]) -> [Element] {

        let idsArray2 = Set(array2.map { $0.id })
        
        var filteredElements = self

        filteredElements.removeAll { item in
            return idsArray2.contains(item.id)
        }
        
        return filteredElements
    }
}
