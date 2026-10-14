//
//  SportsIcon.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/29/26.
//

import SwiftUI

struct SportIcon {

    // MARK: - Properties

    private static let entryDistance: CGFloat = 450
    let name: String
    let position: CGSize
    init(_ name: String, x: CGFloat, y: CGFloat) {
        self.name = name
        self.position = CGSize(width: x, height: y)
    }

    // MARK: - Helpers

    var direction: CGSize {
        let length = max(hypot(position.width, position.height), 1)
        return CGSize(width: position.width / length, height: position.height / length)
    }

    var offscreenPosition: CGSize {
        CGSize(
            width: position.width + direction.width * Self.entryDistance,
            height: position.height + direction.height * Self.entryDistance
        )
    }
}

// MARK: - Icons (positions for the animation)

extension SportIcon {
    static let all: [SportIcon] = [
        SportIcon("Golf-g", x: 46, y: -202),
        SportIcon("Rowing-g", x: -74, y: -190),
        SportIcon("TrackField-g", x: 128, y: -180),
        SportIcon("Wrestling-g", x: -152, y: -158),
        SportIcon("Basketball-g", x: -2, y: -144),
        SportIcon("Lacrosse-g", x: 75, y: -144),
        SportIcon("Gymnastics-g", x: 164, y: -126),
        SportIcon("Sailing-g", x: -100, y: -118),
        SportIcon("Softball-g", x: 112, y: -82),
        SportIcon("CrossCountry-g", x: -154, y: -50),
        SportIcon("FieldHockey-g", x: 164, y: -26),
        SportIcon("Squash-g", x: -116, y: 30),
        SportIcon("Football-g", x: 142, y: 60),
        SportIcon("SwimmingDiving-g", x: -154, y: 101),
        SportIcon("Volleyball-g", x: 86, y: 120),
        SportIcon("Fencing-g", x: -80, y: 128),
        SportIcon("IceHockey-g", x: 2, y: 145),
        SportIcon("Soccer-g", x: 160, y: 145),
        SportIcon("Tennis-g", x: -133, y: 194),
        SportIcon("Baseball-g", x: 82, y: 202),
        SportIcon("Equestrian-g", x: -32, y: 208),
    ]
}
