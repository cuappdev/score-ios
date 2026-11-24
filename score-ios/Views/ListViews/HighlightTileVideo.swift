//
//  HightlightTileVideo.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import SwiftUI

struct HighlightTileVideo: View {
    @Environment(\.openURL) private var openURL

    var video: YouTubeVideo
    var width: CGFloat
    var isBookmarked: Bool
    var isBookmarkPending: Bool = false
    var onBookmarkToggle: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: openVideo) {
                VStack(alignment: .leading, spacing: 1) {
                    RemoteImage(
                        url: URL(string: video.thumbnail),
                        fillsFrame: true,
                        downsampleSize: CGSize(width: width, height: 117)
                    )
                    .frame(width: width, height: 117)
                    .clipped()
                    .overlay(alignment: .bottomLeading) {
                        HStack(spacing: 2) {
                            Image(systemName: "play.fill")
                                .font(.caption2)
                            if let duration = video.duration {
                                Text(duration)
                                    .font(.caption)
                            }
                        }
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        .padding(6)
                    }
                    .clipShape(
                        .rect(
                            topLeadingRadius: 12,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 12
                        )
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text(video.title)
                            .font(.headline)
                            .foregroundStyle(.black)
                            .lineLimit(1)

                        HStack(spacing: 8) {
                            HStack {
                                Text("Youtube")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Constants.Colors.primary_red)
                                    .underline()

                                Image(systemName: "arrow.up.right")
                                    .foregroundStyle(Constants.Colors.primary_red)
                                    .fontWeight(.bold)
                            }

                            Spacer()

                            Text(video.formattedDate)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.horizontal, 12.0)
                    .frame(width: width, height: 75)
                }
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Constants.Colors.white)
                        .shadow(radius: 5)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Constants.Colors.gray_border, lineWidth: 1)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(video.title)

            if video.hasServerId {
                HighlightBookmarkButton(
                    itemTitle: video.title,
                    isBookmarked: isBookmarked,
                    isPending: isBookmarkPending,
                    action: onBookmarkToggle
                )
                .padding(4)
            }
        }
    }

    private func openVideo() {
        guard let url = URL(string: video.url) else { return }
        openURL(url)
    }
}
