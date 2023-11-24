//
//  SeriesScene.swift
//  WatchList
//
//  Created by Mattéo Fauchon on 22/11/2023.
//

import SwiftUI

struct SeriesScene: View {
    
    @StateObject private var store = SeriesStore()
    
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                content
            }
            .scrollIndicators(.never)
            .searchable(text: $searchText, prompt: "Rechercher une série ou un programme") {
                MediaSearchedView(searchText: $searchText, medias: store.all, type: .serie)
            }
            .navigationTitle("Séries")
        }
        .task {
            await store.fetchAllSeries()
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
            onAirContainer
            topRatedContainer
            popularContainer
        }
    }
    
    private var onAirContainer: some View {
        MediasMainSection(header: "À l'affiche", medias: store.onAir, type: .series)
    }
    
    private var popularContainer: some View {
        MediasSection(header: "Populaires", medias: store.popular, type: .series)
    }
    
    private var topRatedContainer: some View {
        MediasSection(header: "Mieux notés", medias: store.topRated, type: .series)
    }
}

#Preview {
    SeriesScene()
}
