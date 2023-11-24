//
//  MoviesListView.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 16/11/2023.
//

import SwiftUI

struct MediasListView: View {
    @EnvironmentObject private var store: MoviesStore
    
    @State private var showDetails = false

    let category: String
    let medias: [any MediaProtocol]
    
    let width = ((UIScreen.main.bounds.width / 2) - 8) - 16
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()], content: {
                ForEach(medias, id: \.id) { media in
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
                    .frame(width: width, height: width * 1.5)
                }
            })
            .padding()
        }
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MediasListView(category: "À l'affiche", medias: Movies.preview)
        .environmentObject(MoviesStore())
}

#Preview {
    MoviesScene()
}
