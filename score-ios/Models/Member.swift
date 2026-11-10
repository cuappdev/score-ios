//
//  Member.swift
//  score-ios
//
//  Created by Duru Alaylı on 11/3/26.
//

import Foundation

struct Member: Identifiable {
    let name: String
    let role: String
    let imageName: String
    var id: String { imageName }
}

// MARK: - Members

extension Member {
    static let fa26Members: [Member] = [
        Member(name: "Claire", role: "Pod Lead", imageName: "member_claire"),
        Member(name: "Duru", role: "APL", imageName: "member_duru"),
        Member(name: "Gillian", role: "Design", imageName: "member_gillian"),
        Member(name: "Adam", role: "Design", imageName: "member_adam"),
        Member(name: "Zain", role: "iOS", imageName: "member_zain"),
        Member(name: "Zara", role: "iOS", imageName: "member_zara"),
        Member(name: "Anik", role: "Backend", imageName: "member_anik"),
        Member(name: "Amy", role: "Android", imageName: "member_amy"),
        Member(name: "Emil", role: "Android", imageName: "member_emil"),
        Member(name: "Maya", role: "Strategy", imageName: "member_maya")
    ]
}

// MARK: - Semester

enum Semester: String, CaseIterable {
    case fa26 = "Fall 2026"
    var members: [Member] {
        switch self {
        case .fa26: Member.fa26Members
        }
    }
}
