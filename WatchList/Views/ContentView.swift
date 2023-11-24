//
//  ContentView.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 14/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .movies

    enum Tab {
        case movies, series
    }
        
    var body: some View {
        TabView(selection: $selectedTab) {
            MoviesScene()
                .tabItem { Label("Movies", systemImage: "movieclapper") }
                .tag(Tab.movies)
            
            SeriesScene()
                .tabItem { Label("Series", systemImage: "play.tv") }
                .tag(Tab.series)
        }
    }
    
}

#Preview {
    ContentView()
}
