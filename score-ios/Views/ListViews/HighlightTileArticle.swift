//
//  HightlightTileArticle.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import SwiftUI

struct HighlightTileArticle: View {
    @Environment(\.openURL) private var openURL

    var article: Article
    var width: CGFloat

    var body: some View {
        Button(action: openArticle) {
            ZStack(alignment: .topLeading) {
                RemoteImage(
                    url: URL(string: article.image),
                    fillsFrame: true,
                    downsampleSize: CGSize(width: width, height: 192)
                )
                .overlay { Color.black.opacity(0.60) }
                .frame(width: width, height: 192)
                .clipped()
                .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 0) {
                    Text(article.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 12)
                        .padding(.trailing, 12)
                        .padding(.horizontal, 12)

                    Spacer()

                    HStack {
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(Constants.Colors.white)
                            .fontWeight(.bold)

                        Spacer()

                        Text(article.formattedDate)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding([.horizontal, .bottom], 12)
                }
                .frame(width: width, height: 192, alignment: .topLeading)
            }
            .shadow(radius: 5)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Constants.Colors.gray_border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(article.title)
    }

    private func openArticle() {
        guard let url = URL(string: article.url) else { return }
        openURL(url)
    }
}
