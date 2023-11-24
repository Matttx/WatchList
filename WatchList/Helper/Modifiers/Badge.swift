//
//  Badge.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 19/11/2023.
//

import Foundation
import SwiftUI

struct Badge: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.alwaysGray700)
            .clipShape(Capsule())
    }
}

extension View {
    func badge() -> some View {
        modifier(Badge())
    }
}
