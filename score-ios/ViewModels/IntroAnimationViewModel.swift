//
//  IntroAnimationViewModel.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/29/26.
//

import SwiftUI

@MainActor
final class IntroAnimationViewModel: ObservableObject {

    // MARK: - Phase

    enum Phase: Int, Comparable {
        case hidden
        case logo
        case icons
        case reveal
        static func < (lhs: Phase, rhs: Phase) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    // MARK: - Properties

    @Published private(set) var phase: Phase = .hidden
    @Published private(set) var rippleTrigger = 0
    @Published private(set) var wobbleTrigger = 0

    static let revealDuration = 0.5
    private let logoDelay = 0.1
    private let logoFadeDuration = 0.1
    private let iconsDelay = 0.2
    private let holdDuration = 2.5
    private let iconStagger = 0.05

    // MARK: - Helpers

    func iconOffset(for icon: SportIcon) -> CGSize {
        phase == .icons ? icon.position : icon.offscreenPosition
    }

    func arrivalDelay(for index: Int) -> Double {
        Double((index * 8) % SportIcon.all.count) * iconStagger
    }

    // MARK: - Animation

    func startAnimation(onFinished: (() -> Void)?) async {
        guard phase == .hidden else { return }
        guard await wait(logoDelay) else { return }
        withAnimation(.easeOut(duration: logoFadeDuration)) { phase = .logo }
        rippleTrigger += 1
        guard await wait(iconsDelay) else { return }
        phase = .icons
        wobbleTrigger += 1
        guard await wait(holdDuration) else { return }
        withAnimation(.easeInOut(duration: Self.revealDuration)) { phase = .reveal }
        guard await wait(Self.revealDuration) else { return }
        onFinished?()
    }

    private func wait(_ seconds: Double) async -> Bool {
        try? await Task.sleep(for: .seconds(seconds))
        return !Task.isCancelled
    }
}
