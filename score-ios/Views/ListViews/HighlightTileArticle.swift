//
//  HightlightTileArticle.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import SwiftUI

struct HighlightTileArticle: View {
    var article: Article
    var width: CGFloat
    
    var body: some View {
        if let url = URL(string: article.url) {
            Link(destination: url) {
                ZStack(alignment: .topLeading) {
                    // Background Image with dark overlay
                    AsyncImage(url: URL(string: article.image)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Constants.Colors.gray_icons.opacity(0.2))
                                .overlay(Color.black.opacity(0.60)) // dark tint
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .overlay(Color.black.opacity(0.60)) // dark tint
                        case .failure(_):
                            Rectangle()
                                .fill(Constants.Colors.gray_icons.opacity(0.3))
                                .overlay(
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding()
                                        .overlay(Color.black.opacity(0.60)) // dark tint
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: width, height: 192)
                    .clipped()
                    .cornerRadius(12)
                    
                    // Text overlay
                    VStack(alignment: .leading, spacing: 0) {
                        // Title at top left
                        Text(article.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 12)
                            .padding(.horizontal, 24)
                        
                        Spacer()
                        
                        // Source and date at bottom
                        HStack {
                            Text(article.source)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(Constants.Colors.white)
                                .underline()
                            
                            Image(systemName: "arrow.up.right")
                                .foregroundStyle(Constants.Colors.white)
                                .fontWeight(.bold)
                    
                            Spacer()
                            
                            Text(article.formattedDate)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding([.horizontal, .bottom], 12)
                    }
                    .frame(width: width, height: 192, alignment: .topLeading)

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


// MARK: - Preview

#Preview {
    HighlightTileArticle(article: Article.dummyData[0], width: 345)
}

