//
//  MediasSection.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 23/11/2023.
//

import SwiftUI

struct MediasSection: View {
    
    let header: String
    
    let medias: [any MediaProtocol]
    
    let type: MediaType
    
    enum MediaType: String {
        case movies = "Films"
        case series = "Séries"
    }
    
    var body: some View {
        if !medias.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(header)
                        .font(.headline)
                    Spacer()
                    if medias.count > 6 {
                        NavigationLink {
                            MediasListView(category: "\(type.rawValue) similaires", medias: medias)
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
                        ForEach(medias.prefix(7), id: \.id) { media in
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
                            .frame(width: 175, height: 175 * 1.5)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    MediasSection(header: "Populaires", medias: Movies.preview, type: .movies)
}
