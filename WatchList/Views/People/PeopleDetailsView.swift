//
//  PeopleDetailsView.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 20/11/2023.
//

import SwiftUI

struct PeopleDetailsView: View {
    @StateObject private var store = PeopleStore()
    
    let id: Int
    
    @State private var biographySeeMore: Bool = false
    
    var body: some View {
        ScrollView {
            content
        }
        .navigationTitle("Informations")
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
    
    private var successContent: some View {
        VStack(spacing: 16) {
            headerContainer
            biographyContainer
            filmsAndSeriesContainer
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var headerContainer: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: store.details?.profilePath ?? "")) { image in
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
            .frame(width: 120, height: 120 * 1.5)
            .shadow(radius: 5)

            VStack(alignment: .leading, spacing: 8) {
                Text(store.details?.name ?? "Inconnu")
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                humanInfosContainer
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
    
    private var humanInfosContainer: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                Text("Genre")
                    .font(.subheadline)
                    .foregroundStyle(.gray600)
                if let gender = store.details?.gender {
                    Text(gender == 1 ? "Femme" : "Homme")
                }
            }
            
            VStack(alignment: .leading) {
                Text("Date et lieu de naissance")
                    .font(.subheadline)
                    .foregroundStyle(.gray600)
                Text(store.details?.birthAndDeathLabel ?? "Date inconnue")
                Text(store.details?.birthPlace ?? "Lieu inconnu")
            }
            .multilineTextAlignment(.leading)
        }
    }
    
    @ViewBuilder
    private var biographyContainer: some View {
        if let biography = store.details?.biography, !biography.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Biographie")
                    .font(.headline)
                Text(store.details?.biography ?? "")
                    .font(.body)
                    .lineLimit(biographySeeMore ? nil : 10)
                Button {
                    biographySeeMore.toggle()
                } label: {
                    Text(biographySeeMore ? "Voir moins" : "Voir plus")
                        .font(.callout)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var filmsAndSeriesContainer: some View {
        if let movies = store.details?.cast {
            MediasScrollList(header: "Films et programmes TV", medias: movies)
        }
    }
}

#Preview {
    NavigationStack {
        PeopleDetailsView(id: 2037)
    }
}
