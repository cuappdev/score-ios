//
//  TimeUpdate.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/23/25.
//

import SwiftUI

struct TimeUpdate {
    var id: UUID = UUID()
    var timestamp: Int
    var isTotal: Bool
    var cornellScore: Int
    var opponentScore: Int
}
