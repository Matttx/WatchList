//
//  MovieDetailsView.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 16/11/2023.
//

import SwiftUI

struct MovieDetailsView: View {
    
    @StateObject private var store = MovieDetailsStore()
    
    let id: Int
    
    // MARK: - Views
    
    var body: some View {
        ScrollView() {
            content
        }
        .navigationTitle("Détails")
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.never)
        .task {
            await store.fetchDetails(id)
        }
        .refreshable {
            Task {
                await store.fetchDetails(id)
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch store.phase {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
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
    
    @ViewBuilder
    private var successContent: some View {
        VStack(spacing: 16) {
            backdropHeader
            infosContainer
            creditsContainer
            similarMoviesContainer
        }
        .padding(.vertical)
    }
    
    // MARK: - Backdrop Header
    private var backdropHeader: some View {
        MediaBackgroundHeader(
            path: store.details?.backdropPath ?? "",
            title: store.details?.title ?? "",
            tagline: store.details?.tagline,
            details: "\(store.details?.runtime ?? 0) mins • \(store.details?.releaseDate?.toDate(format: "dd/MM/yyyy").year ?? "") • \(store.details?.voteAverage?.round(decimals: 2) ?? "??")/10")
    }
    
    // MARK: - Infos
    
    private var infosContainer: some View {
        VStack(alignment: .leading, spacing: 16) {
            genresContainer
            overviewContainer
            productionContainer
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var genresContainer: some View {
        if let genres = store.details?.genres, !genres.isEmpty {
            MediaGenres(genres: genres.compactMap {$0.name})
        }
    }
    
    @ViewBuilder
    private var overviewContainer: some View {
        if let overview = store.details?.overview, !overview.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Synopsys")
                    .font(.headline)

                Text(store.details?.overview ?? "")
                    .font(.body)
            }
        }
    }
    
    @ViewBuilder
    private var productionContainer: some View {
        if let companies = store.details?.productionCompanies, !companies.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Production")
                    .font(.headline)

                HStack(spacing: 8) {
                    Text(companies.compactMap { $0.name }.joined(separator: ", "))
                }
                .font(.callout)
            }
        }
    }
    
    private var creditsContainer: some View {
        VStack(alignment: .leading, spacing: 8) {
            castingContainer
            directorContainer
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var directorContainer: some View {
        if let director = store.details?.credits?.director {
            VStack(alignment: .leading, spacing: 8) {
                Text("Directeur")
                    .font(.headline)

                castingPreviewItem(casting: director)
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var castingContainer: some View {
        if let casting = store.details?.credits?.cast, !casting.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Acteurs")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 4) {
                        ForEach(casting.prefix(6), id: \.id) { actor in
                            castingPreviewItem(casting: actor)
                        }
                    }
                    .padding(.horizontal)
                }
                .scrollIndicators(.never)
            }
        }
    }
    
    private func castingPreviewItem(casting: Credits.Cast) -> some View {
        NavigationLink {
            if let id = casting.id {
                PeopleDetailsView(id: id)
            }
        } label: {
            MediaCastingPreview(path: casting.profilePath ?? "", name: casting.name)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 120)
    }
    
    @ViewBuilder
    private var similarMoviesContainer: some View {
        if let similarMovies = store.details?.similarMovies, !similarMovies.isEmpty {
            MediasScrollList(header: "Films similaires", medias: similarMovies)
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailsView(id: 872585)
    }
}
