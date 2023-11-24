//
//  SerieDetailsView.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 23/11/2023.
//

import SwiftUI

struct SerieDetailsView: View {
    @StateObject private var store = SerieDetailsStore()
    
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
            seasonsContainer
            productionContainer
            creditsContainer
            similarSeriesContainer
        }
        .padding(.vertical)
    }
    
    // MARK: - Backdrop Header
    private var backdropHeader: some View {
        MediaBackgroundHeader(
            path: store.details?.backdropPath ?? "",
            title: store.details?.name ?? "",
            tagline: store.details?.tagline,
            details: "\(store.details?.seasons?.count ?? 0) saisons • \(store.details?.voteAverage?.round(decimals: 2) ?? "??")/10")
    }
    
    private var infosContainer: some View {
        VStack(alignment: .leading, spacing: 16) {
            genresContainer
            overviewContainer
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
    private var seasonsContainer: some View {
        if let seasons = store.details?.seasons, !seasons.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Saisons")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 4) {
                        ForEach(seasons, id: \.id) { season in
                            VStack {
                                AsyncImage(url: URL(string: season.posterPath ?? "")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(.gray50)
                                        .overlay {
                                            ProgressView()
                                        }
                                        .shadow(radius: 5)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(width: 120)
                                
                                if let name = season.name {
                                    Text(name)
                                        .font(.callout)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .frame(width: 110)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .font(.callout)
                }
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
    }
    
    private var creditsContainer: some View {
        castingContainer
            .frame(maxWidth: .infinity, alignment: .leading)
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
    private var similarSeriesContainer: some View {
        if let similarSeries = store.details?.similarSeries, !similarSeries.isEmpty {
            MediasScrollList(header: "Séries similaires", medias: similarSeries)
        }
    }
}

#Preview {
    SerieDetailsView(id: 1396)
}
