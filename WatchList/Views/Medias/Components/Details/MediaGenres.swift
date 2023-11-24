//
//  MediaGenres.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 23/11/2023.
//

import SwiftUI

struct MediaGenres: View {
    
    let genres: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Genre")
                .font(.headline)

            HStack(spacing: 8) {
                ForEach(genres.prefix(3), id: \.self) {
                    Text($0)
                        .badge()
                }
            }
            .font(.callout)
        }
    }
}

#Preview {
    MediaGenres(genres: ["Drama", "Action"])
}
