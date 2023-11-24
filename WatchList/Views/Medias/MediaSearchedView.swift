//
//  MediaSearchedView.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 22/11/2023.
//

import SwiftUI

struct MediaSearchedView: View {

    init(searchText: Binding<String>, medias: [any MediaProtocol], type: MediaType) {
        self._searchText = searchText
        self.medias = medias
        self.type = type
    }
    
    @Binding var searchText: String

    let medias: [any MediaProtocol]
    
    let type: MediaType
    
    enum MediaType {
        case movie, serie
    }
    
    var body: some View {
        if !searchText.isEmpty {
            ForEach(medias.filter {$0.title?.lowercased().contains(searchText.lowercased()) ?? false}, id: \.id) { media in
                NavigationLink {
                    if let id = media.id {
                        if type == .movie {
                            MovieDetailsView(id: id)
                        } else {
                            SerieDetailsView(id: id)
                        }
                    }
                } label: {
                    MediaSearchableRow(media: media)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    MediaSearchedView(searchText: .constant(""), medias: Movies.preview, type: .movie)
}
