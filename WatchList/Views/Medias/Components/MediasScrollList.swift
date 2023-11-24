//
//  MediasScrollList.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 23/11/2023.
//

import SwiftUI

struct MediasScrollList: View {
    
    let header: String
    
    let medias: [any MediaProtocol]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(header)
                    .font(.headline)
                Spacer()
                if medias.count > 6 {
                    NavigationLink {
                        MediasListView(category: header, medias: medias)
                    } label: {
                        HStack(spacing: 2) {
                            Text("Voir plus")
                                .font(.callout)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                    }
                }
            }
            .padding(.horizontal)

            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(medias.prefix(5), id: \.id) { media in
                        NavigationLink {
                            if let id = media.id {
                                if media.type == "movie" {
                                    MovieDetailsView(id: id)
                                } else {
                                    SerieDetailsView(id: id)
                                }
                            }
                        } label: {
                            PosterCard(media: media)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 200, height: 300)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    MediasScrollList(header: "À l'affiche", medias: Movies.preview)
}
