//
//  MediasMainSection.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 23/11/2023.
//

import SwiftUI

struct MediasMainSection: View {
    
    let header: String
    
    let medias: [any MediaProtocol]
    
    let type: MediaType
    
    enum MediaType: String {
        case movies
        case series
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("À l'affiche")
                    .font(.headline)
                Spacer()
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
            .padding(.horizontal)
            
            ScrollView(.horizontal) {
                HStack(spacing: 24) {
                    ForEach(medias.prefix(10), id: \.id) { media in
                        NavigationLink {
                            if let id = media.id {
                                if type == .movies {
                                    MovieDetailsView(id: id)
                                } else {
                                    SerieDetailsView(id: id)
                                }
                            }
                        } label: {
                            PosterCard(media: media)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 250, height: 400)
                        .scrollTransition { effect, phase in
                            effect
                                .scaleEffect(phase.isIdentity ? 1 : 0.9)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    MediasMainSection(header: "À l'affiche", medias: Movies.preview, type: .movies)
}
