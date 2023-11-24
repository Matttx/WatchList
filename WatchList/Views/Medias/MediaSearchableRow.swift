//
//  MovieSearchableRow.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 16/11/2023.
//

import SwiftUI

struct MediaSearchableRow: View {
    @EnvironmentObject private var store: MoviesStore
    
    let media: any MediaProtocol
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: media.poster ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(media.title ?? "")
                    .font(.headline)
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.accent)
                    Text("\(String(format: "%.2f", media.ratingAverage ?? 0))")
                }
                .font(.callout)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

#Preview {
    MediaSearchableRow(media: Movies.Movie.preview)
        .environmentObject(MoviesStore())
}
