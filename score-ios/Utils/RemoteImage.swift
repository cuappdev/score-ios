//
//  RemoteImage.swift
//  score-ios
//
//  Created by Zain Bilal on 10/24/26.
//

import Kingfisher
import SwiftUI

struct RemoteImage: View {
    var url: URL?
    var fillsFrame = false
    /// Point size. Kingfisher downsamples to this instead of decoding the full image.
    var downsampleSize: CGSize?

    var body: some View {
        Group {
            if fillsFrame {
                image.scaledToFill()
            } else {
                image
            }
        }
    }

    private var image: KFImage {
        let image = KFImage(url)
            .placeholder {
                Rectangle()
                    .fill(Constants.Colors.gray_icons.opacity(0.2))
            }
            .onFailureView {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Constants.Colors.gray_icons)
                    .padding(8)
            }
        guard let downsampleSize, downsampleSize.width > 0, downsampleSize.height > 0 else {
            return image.resizable()
        }
        return image
            .downsampling(size: downsampleSize)
            .resizable()
    }
}
