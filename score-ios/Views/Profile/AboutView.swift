//
//  AboutView.swift
//  score-ios
//
//  Created by Duru Alaylı on 11/3/26.
//

import SwiftUI

struct AboutView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 20) {
                    title
                    ForEach(Semester.allCases, id: \.self) { semester in
                        MembersGridView(title: semester.rawValue, members: semester.members)
                    }
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Header

    private var header: some View {
        ZStack {
            Text("About Score")
                .font(Constants.Fonts.medium18)
                .foregroundStyle(Constants.Colors.black)
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("arrow_back_ios")
                        .resizable()
                        .frame(width: 9.87, height: 18.57)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Constants.Colors.white)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .zIndex(1)
    }

    // MARK: - Title

    private var title: some View {
        VStack(spacing: 8) {
            Image("Rocket")
                .resizable()
                .renderingMode(.template)
                .frame(width: 44, height: 96)
                .foregroundStyle(Constants.Colors.crimson)
            Text("Designed and developed by:")
                .font(Constants.Fonts.sportLabel)
                .foregroundStyle(Constants.Colors.primary_gray)
            Text("Cornell\(Text("AppDev").font(Constants.Fonts.semibold24))")
                .font(Font.custom("Poppins Regular", size: 24))
                .foregroundStyle(Constants.Colors.black)
        }
    }
}

// MARK: - Members Grid

private struct MembersGridView: View {

    // MARK: - Properties

    let title: String
    let members: [Member]
    private let rowSizes = [2, 3, 3, 2]

    private var rows: [[Member]] {
        var result: [[Member]] = []
        var index = 0
        for size in rowSizes where index < members.count {
            let end = min(index + size, members.count)
            result.append(Array(members[index..<end]))
            index = end
        }
        if index < members.count {
            result.append(Array(members[index...]))
        }
        return result
    }

    // MARK: - UI

    var body: some View {
        VStack {
            header
            content
        }
    }

    private var header: some View {
        Text(title)
            .font(Constants.Fonts.bodyBold)
            .foregroundStyle(Constants.Colors.black)
            .multilineTextAlignment(.center)
    }

    private var content: some View {
        VStack(spacing: 18) {
            ForEach(rows.indices, id: \.self) { index in
                HStack(spacing: 16) {
                    ForEach(rows[index]) { member in
                        memberCell(member)
                            .frame(width: 100)
                    }
                }
            }
        }
        .padding(.top, 16)
    }

    private func memberCell(_ member: Member) -> some View {
        VStack {
            Image(member.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())

            Text(member.name)
                .font(Constants.Fonts.bodyBold)
                .foregroundStyle(Constants.Colors.primary_gray)

            Text(member.role)
                .font(Constants.Fonts.medium14)
                .foregroundStyle(Constants.Colors.gray_text)
        }
    }
}

#Preview {
    AboutView()
}
