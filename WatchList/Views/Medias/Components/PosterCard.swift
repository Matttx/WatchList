//
//  PosterCard.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 16/11/2023.
//

import SwiftUI

struct PosterCard: View {
    let media: any MediaProtocol
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: media.poster ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(.gray50)
                    .shadow(radius: 5)
                    .foregroundStyle(.clear)
                    .overlay {
                        ProgressView()
                    }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
            .shadow(radius: 5)
        }
    }
}

#Preview {
    PosterCard(media: Movies.Movie.preview)
        .frame(width: 200, height: 300)
        .environmentObject(MoviesStore())
}
