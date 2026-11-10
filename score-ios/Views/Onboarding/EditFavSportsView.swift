//
//  EditFavSportsView.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/29/26.
//

import SwiftUI

struct EditFavSportsView: View {

    // MARK: - Properties

    var isOnboarding = true
    var onDone: (() -> Void)?
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = EditFavSportsViewModel()
    @State private var selectedSex: Sex = Sex.allCases[0]
    @State private var selectedIndex = 0

    private let sports = Sport.allCases
        .filter { $0 != .All }
        .sorted { $0.description < $1.description }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 24), count: 3)

    private var cards: [SportCard] {
        let all = sports.flatMap { sport in
            sport.genders
                .filter { selectedSex == .Both || $0 == selectedSex }
                .map { SportCard(sport: sport, sex: $0) }
        }
        let saved = all.filter { viewModel.savedFavorites.contains($0.team) }
        let others = all.filter { !viewModel.savedFavorites.contains($0.team) }
        return saved + others
    }

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            if !isOnboarding {
                settingsHeader
            }
            VStack(spacing: 32) {
                if isOnboarding {
                    header
                }
                PickerView(selectedSex: $selectedSex, selectedIndex: $selectedIndex)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(cards) { card in
                            sportCard(card)
                        }
                    }
                    .animation(nil, value: selectedSex)
                }
                .contentMargins(.top, 10, for: .scrollContent)
                .contentMargins(.leading, 10, for: .scrollContent)
                if isOnboarding {
                    buttons
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, isOnboarding ? 60 : 0)
            .padding(.top, isOnboarding ? 32 : 24)
        }
        .onAppear {
            viewModel.loadFavorites()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .alert("Couldn't save your favorites. Please try again.", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        }
    }

    // MARK: - Headers

    private var header: some View {
        VStack {
            Text("Select Favorite Sports")
                .font(Constants.Fonts.Header.h1)
                .foregroundStyle(Constants.Colors.primary_gray)
                .frame(maxWidth: .infinity)
            Text("You can change your picks at any time!")
                .font(Constants.Fonts.medium14)
                .foregroundStyle(Constants.Colors.primary_gray)
                .frame(maxWidth: .infinity)
        }
    }

    private var settingsHeader: some View {
        ZStack {
            Text("Favorite Sports")
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
                Button {
                    save()
                } label: {
                    Text("Finish")
                        .font(Constants.Fonts.Label.medium)
                        .foregroundStyle(Constants.Colors.crimson)
                }
                .disabled(viewModel.isSaving)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Constants.Colors.white)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .zIndex(1)
    }

    // MARK: - Sport Card

    private func sportCard(_ card: SportCard) -> some View {
        let isSelected = viewModel.isSelected(card.team)
        return Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                viewModel.toggle(card.team)
            }
        } label: {
            VStack(spacing: 8) {
                ZStack(alignment: .topLeading) {
                    Image(card.sport.iconName)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 45, height: 45)
                        .foregroundStyle(isSelected ? Constants.Colors.green : Constants.Colors.primary_gray)
                        .padding(24)
                        .background(isSelected ? Constants.Colors.green_background : Constants.Colors.gray_border)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Constants.Colors.green, lineWidth: isSelected ? 3 : 0)
                        )
                    if isSelected {
                        Image("remove")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(4)
                            .background(Constants.Colors.crimson)
                            .clipShape(Circle())
                            .offset(x: -6, y: -4)
                    }
                }
                VStack {
                    Text(card.sport.description)
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.primary_gray)
                        .multilineTextAlignment(.center)
                    HStack(spacing: 4) {
                        Text(card.sex.symbol)
                            .font(Constants.Fonts.medium14)
                            .foregroundStyle(Constants.Colors.primary_gray)
                            .padding(4)
                            .background(Constants.Colors.gray_border)
                            .clipShape(Circle())
                        Text(card.sex.letter)
                            .font(Constants.Fonts.buttonLabel)
                            .foregroundStyle(Constants.Colors.primary_gray)
                    }
                }
            }
        }
    }

    // MARK: - Buttons

    private var buttons: some View {
        VStack(spacing: 16) {
            Button {
                save()
            } label: {
                Text(viewModel.selected.isEmpty ? "Finish" : "Finish with ^[\(viewModel.selected.count) sport](inflect: true)")
                    .font(Constants.Fonts.Header.h3)
                    .foregroundStyle(Constants.Colors.white)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Constants.Colors.crimson)
                    .clipShape(Capsule())
            }
            .disabled(viewModel.isSaving)
            if AuthManager.shared.currentUser != nil {
                HStack(spacing: 4) {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(Constants.Colors.gray_liner)
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(Constants.Colors.crimson)
                }
            }
        }
    }

    // MARK: - Helpers

    private func save() {
        Task {
            guard await viewModel.saveFavorites() else { return }
            if let onDone {
                onDone()
            } else {
                dismiss()
            }
        }
    }
}

// MARK: - Sport Card Model

private struct SportCard: Identifiable {
    let sport: Sport
    let sex: Sex
    var id: String { "\(sport.rawValue)-\(sex)" }
    var team: FavoriteTeam { FavoriteTeam(sport: sport.description, gender: sex.filterDescription) }
}

#Preview {
    EditFavSportsView()
}
