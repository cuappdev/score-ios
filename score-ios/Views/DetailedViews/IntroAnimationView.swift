//
//  IntroAnimationView.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/29/26.
//

import SwiftUI

struct IntroAnimationView: View {

    // MARK: - Properties

    @StateObject private var viewModel = IntroAnimationViewModel()
    var onFinished: (() -> Void)?

    // MARK: - Constants

    private let topPadding: CGFloat = 229
    private let logoSize: CGFloat = 197
    private let logoStartScale: CGFloat = 0.4
    private let logoBadgeScale: CGFloat = 0.75
    private let logoDropOffset: CGFloat = 60
    private let circleSize: CGFloat = 150
    private let circleStartScale: CGFloat = 0.4
    private let iconSize: CGFloat = 28
    private let iconExitDuration = 0.4
    private let ringDelays = [0.6, 0.9]
    private let shakeStep = 0.06
    private let shakeAngles: [Double] = [15, -15, 12, -12, 8, -8, 4, 0]
    private let shakePushes: [Double] = [8, -7, 6, -5, 4, -3, 2, 0]

    // MARK: - UI

    var body: some View {
        ZStack {
            Constants.Colors.crimson.ignoresSafeArea()

            VStack {
                logo
                    .background(ZStack { circle; rings })
                    .overlay(icons)
                    .offset(y: viewModel.phase >= .reveal ? 0 : logoDropOffset)

                Spacer()
            }
            .padding(.top, topPadding)
        }
        .task {
            await viewModel.startAnimation(onFinished: onFinished)
        }
    }

    // MARK: - Logo

    private var logo: some View {
        Image("Logo")
            .resizable()
            .frame(width: logoSize, height: logoSize)
            .scaleEffect(viewModel.phase >= .reveal ? 1 : logoBadgeScale)
            .scaleEffect(viewModel.phase == .hidden ? logoStartScale : 1)
            .opacity(viewModel.phase == .hidden ? 0 : 1)
            .animation(
                viewModel.phase == .logo
                    ? .spring(response: 0.45, dampingFraction: 0.45)
                    : .easeInOut(duration: IntroAnimationViewModel.revealDuration),
                value: viewModel.phase
            )
    }

    private var circle: some View {
        Circle()
            .fill(Color.white.opacity(0.08))
            .frame(width: circleSize, height: circleSize)
            .scaleEffect(viewModel.phase >= .logo ? 1 : circleStartScale)
            .opacity(viewModel.phase == .logo || viewModel.phase == .icons ? 1 : 0)
    }

    // MARK: - Rings

    private var rings: some View {
        ZStack {
            ForEach(ringDelays, id: \.self) { delay in
                ring(delay: delay)
            }
        }
    }

    private func ring(delay: Double) -> some View {
        Circle()
            .fill(Color.white.opacity(0.06))
            .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
            .frame(width: circleSize, height: circleSize)
            .keyframeAnimator(initialValue: Ripple(), trigger: viewModel.rippleTrigger) { view, ripple in
                view
                    .scaleEffect(ripple.scale)
                    .opacity(ripple.opacity)
            } keyframes: { _ in
                rippleKeyframes(delay: delay)
            }
    }

    // MARK: - Icons

    private var icons: some View {
        ForEach(SportIcon.all.indices, id: \.self) { index in
            let icon = SportIcon.all[index]
            let delay = viewModel.arrivalDelay(for: index)
            Image(icon.name)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(.white)
                .keyframeAnimator(initialValue: Wobble(), trigger: viewModel.wobbleTrigger) { view, wobble in
                    view
                        .scaleEffect(wobble.scale)
                        .rotationEffect(.degrees(wobble.angle))
                        .offset(
                            x: icon.direction.width * wobble.push,
                            y: icon.direction.height * wobble.push + wobble.hop
                        )
                } keyframes: { _ in
                    wobbleKeyframes(delay: delay, direction: index.isMultiple(of: 2) ? 1 : -1)
                }
                .offset(viewModel.iconOffset(for: icon))
                .opacity(viewModel.phase == .icons ? 1 : 0)
                .animation(
                    viewModel.phase == .icons
                        ? .spring(response: 0.3, dampingFraction: 0.5).delay(delay)
                        : .easeIn(duration: iconExitDuration),
                    value: viewModel.phase
                )
        }
    }
}

// MARK: - Keyframes

private struct Wobble {
    var angle = 0.0
    var scale = 1.0
    var hop = 0.0
    var push = 0.0
}

private struct Ripple {
    var scale = 0.3
    var opacity = 0.0
}

private extension IntroAnimationView {
    @KeyframesBuilder<Wobble>
    func wobbleKeyframes(delay: Double, direction d: Double) -> some Keyframes<Wobble> {
        let landed = delay + 0.30
        KeyframeTrack(\.angle) {
            LinearKeyframe(0, duration: landed)
            for angle in shakeAngles {
                LinearKeyframe(angle * d, duration: shakeStep)
            }
        }
        KeyframeTrack(\.push) {
            LinearKeyframe(0, duration: landed)
            for push in shakePushes {
                LinearKeyframe(push, duration: shakeStep)
            }
        }
        KeyframeTrack(\.scale) {
            MoveKeyframe(1.3)
            LinearKeyframe(1.3, duration: delay + 0.25)
            SpringKeyframe(0.94, duration: 0.21, spring: Spring(mass: 1, stiffness: 100, damping: 10))
            SpringKeyframe(1.0,  duration: 0.18, spring: Spring(mass: 1, stiffness: 100, damping: 16))
        }
        KeyframeTrack(\.hop) {
            LinearKeyframe(0,  duration: delay + 0.70)
            LinearKeyframe(-5, duration: 0.16, timingCurve: .easeInOut)
            LinearKeyframe(0,  duration: 0.16, timingCurve: .easeInOut)
        }
    }
    @KeyframesBuilder<Ripple>
    func rippleKeyframes(delay: Double) -> some Keyframes<Ripple> {
        KeyframeTrack(\.scale) {
            LinearKeyframe(0.3, duration: delay)
            LinearKeyframe(1.7, duration: 1.0, timingCurve: .easeOut)
        }
        KeyframeTrack(\.opacity) {
            LinearKeyframe(0, duration: delay)
            LinearKeyframe(1, duration: 0.1)
            LinearKeyframe(1, duration: 0.4)
            LinearKeyframe(0, duration: 0.5, timingCurve: .easeIn)
        }
    }
}

#Preview {
    IntroAnimationView()
}
