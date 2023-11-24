//
//  MoviesScene.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 16/11/2023.
//

import SwiftUI

struct MoviesScene: View {
    
    @StateObject private var store = MoviesStore()
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                content
            }
            .scrollIndicators(.never)
            .searchable(text: $searchText, prompt: "Rechercher un film") {
                MediaSearchedView(searchText: $searchText, medias: store.all, type: .movie)
            }
            .navigationTitle("Films")
        }
        .task {
            await store.fetchAllMovies()
        }
        .refreshable {
            Task {
                await store.refreshView()
            }
        }
        .environmentObject(store)
    }
    
    @ViewBuilder
    private var content: some View {
        switch store.phase {
        case .loading:
            ProgressView()
        case .success:
            successContent
        case .failure:
            failureContent
        case .none:
            EmptyView()
        }
    }
    
    private var failureContent: some View {
        Text("\(store.error?.localizedDescription ?? "")")
            .multilineTextAlignment(.center)
    }
    
    private var successContent: some View {
        VStack(spacing: 0) {
            nowPlayingContainer
            popularContainer
            topRatedContainer
        }
    }
    
    private var nowPlayingContainer: some View {
        MediasMainSection(header: "À l'affiche", medias: store.nowPlaying, type: .movies)
    }
    
    private var popularContainer: some View {
        MediasSection(header: "Populaires", medias: store.popular, type: .movies)
    }
    
    private var topRatedContainer: some View {
        MediasSection(header: "Mieux notés", medias: store.topRated, type: .movies)
    }
    
}

#Preview {
    MoviesScene()
}
