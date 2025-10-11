//
//  HightlightTileVideo.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import SwiftUI

struct HighlightTileVideo: View {
    var video: YoutubeVideo
    var width: CGFloat
    
    var body: some View {
        
        if let url = URL(string: video.url) {
            Link(destination: url) {
                VStack(alignment: .leading, spacing: 1) {
                    // Thumbnail
                    AsyncImage(url: URL(string: video.thumbnail)) { phase in
                        switch phase {
                        case .empty:
                            // While loading
                            Rectangle()
                                .fill(Constants.Colors.gray_icons.opacity(0.2))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure(_):
                            // If loading fails
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: width, height: 117)
                    .clipped()
                    .overlay(
                        // Duration placeholder (if you add it later)
                        HStack(spacing: 2){
                            Image(systemName: "play.fill")
                                .font(.caption2)
                                                
                            Text("1:25")
                                .font(.caption)
                        }
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            
                            .padding(6)
                        .clipShape(RoundedRectangle(cornerRadius: 4)),
                        alignment: .bottomLeading
                       
                    )
                    .cornerRadius(12, corners: [.topLeft, .topRight])

                    
                    VStack(alignment: .leading, spacing: 8){
                        // Title
                        Text(video.title)
                            .font(.headline)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        
                        
                        // Youtube + Date
                        HStack(spacing: 8) {
                            if let url = URL(string: video.url) {
                                Link(destination: url) {
                                    HStack{
                                        Text("Youtube")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Constants.Colors.primary_red)
                                            .underline()
                                        
                                        Image(systemName: "arrow.up.right")
                                            .foregroundStyle(Constants.Colors.primary_red)
                                            .fontWeight(.bold)
                                    }
                                   
                                }
                            }
                            
                            Spacer()
                            
                            Text(video.formattedDate)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }.padding(.horizontal, 12.0)
                    .frame(width: width, height: 75)
                   
                }
                
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Constants.Colors.gray_border, lineWidth: 1)
                        .shadow(radius: 5)
                )
            }
            }
        }
}

// MARK: - Model

struct YoutubeVideo: Identifiable {
    var id: String
    var title: String
    var description: String
    var thumbnail: String
    var b64Thumbnail: String?
    var url: String
    var publishedAt: String
    
    // Format publishedAt -> MM/dd or similar
    var formattedDate: String {
        if let date = ISO8601DateFormatter().date(from: publishedAt) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter.string(from: date)
        }
        return publishedAt
    }
}

#Preview {
    HighlightTileVideo(video: YoutubeVideo(
        id: "QGHb9heJAco",
        title: "Cornell Celebrates Coach Mike Schafer '86",
        description: "Cornell Celebrates Coach Mike Schafer '86 Narrated by Jeremy Schaap '91.",
        thumbnail: "https://i.ytimg.com/vi/QGHb9heJAco/hqdefault.jpg",
        b64Thumbnail: nil,
        url: "https://youtube.com/watch?v=QGHb9heJAco",
        publishedAt: "2024-11-09T00:00:00Z"
    ), width: 241)
}
