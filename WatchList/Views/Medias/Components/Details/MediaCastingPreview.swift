//
//  MediaCastingPreview.swift
//  WatchList
//
//  Created by Mattéo Fauchon  on 23/11/2023.
//

import SwiftUI

struct MediaCastingPreview: View {
    
    let path: String
    let name: String?
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: path)) { image in
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
            
            if let name = name {
                Text(name)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
    }
}

#Preview {
    MediaCastingPreview(path: "", name: "Cillian Murphy")
}
