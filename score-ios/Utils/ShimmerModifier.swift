//
//  ShimmerModifier.swift
//  score-ios
//
//  Created by Jayson Hahn on 3/22/25.
//

import Foundation
import SwiftUI

/// A view modifier that applies a shimmer effect.
struct ShimmerEffect: ViewModifier {

    @State private var moveTo: CGFloat = -1.5

    func body(content: Content) -> some View {
        content
            .hidden()
            .overlay {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .mask {
                        content
                    }
                    .overlay {
                        GeometryReader {
                            let size = $0.size
                            Rectangle()
                                .fill(Color.white.opacity(0.85))
                                .mask {
                                    Rectangle()
                                        .fill(
                                            .linearGradient(
                                                colors: [
                                                    .white.opacity(0),
                                                    .white.opacity(0.85).opacity(1),
                                                    .white.opacity(0)
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(width: 100)
                                        .frame(maxHeight: .infinity)
                                        .blur(radius: 30)
                                        .rotationEffect(.init(degrees: 30))
                                        .offset(x: size.width * moveTo, y: 0)
                                }
                        }
                        .mask {
                            content
                        }
                    }
            }
            .onAppear { // Move onAppear out of the overlay chain
                DispatchQueue.main.async {
                    moveTo = 1.5
                }
            }
            .animation(.linear(duration: 1.3).repeatForever(autoreverses: false), value: moveTo)
    }
}

extension View {

    @ViewBuilder
    func shimmer() -> some View {
        self
            .modifier(ShimmerEffect())
    }

}
