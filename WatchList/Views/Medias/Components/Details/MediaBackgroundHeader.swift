//
//  MediaBackgroundHeader.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 23/11/2023.
//

import SwiftUI

struct MediaBackgroundHeader: View {
    
    let path: String
    let title: String
    let tagline: String?
    let details: String
    
    let width = UIScreen.main.bounds.width - 32

    var body: some View {
        AsyncImage(url: URL(string: path)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: width, height: 200)
                .foregroundStyle(.gray50)
                .overlay {
                    ProgressView()
                }
                
        }
        .overlay(alignment: .bottom) {
            detailsContainer
        }
        .frame(width: width)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .shadow(radius: 5)
    }

    private var detailsContainer: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            if let tagline = tagline, !tagline.isEmpty {
                Text(tagline)
                    .font(.caption)
            }
            Text(details)
                .font(.caption)
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.alwaysGray900]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        
    }
}

#Preview {
    MediaBackgroundHeader(path: "", title: "Oppenheimer", tagline: "Ceci est une tagline", details: "Test")
}
