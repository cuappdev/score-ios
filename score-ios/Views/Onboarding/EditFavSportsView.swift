//
//  EditFavSportsView.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/29/26.
//

import SwiftUI

struct EditFavSportsView: View {

    // MARK: - Properties

    var onDone: (() -> Void)?
    @StateObject private var viewModel = EditFavSportsViewModel()
    @State private var selectedSex: Sex = Sex.allCases[0]
    @State private var selectedIndex = 0

    private let sports = Sport.allCases
        .filter { $0 != .All }
        .sorted { $0.description < $1.description }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 24), count: 3)
    
    private var cards: [SportCard] {
        sports.flatMap { sport in
            sport.genders
                .filter { selectedSex == .Both || $0 == selectedSex }
                .map { SportCard(sport: sport, sex: $0) }
        }
    }

    // MARK: - UI

    var body: some View {
        VStack(spacing: 32) {
            header
            PickerView(selectedSex: $selectedSex, selectedIndex: $selectedIndex)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(cards) { card in
                        sportCard(sport: card.sport, sex: card.sex)
                    }
                }
                .animation(nil, value: selectedSex)
            }
            .contentMargins(.top, 10, for: .scrollContent)
            .contentMargins(.leading, 10, for: .scrollContent)
            buttons
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 60)
        .padding(.top, 32)
        .onAppear {
            viewModel.loadFavorites()
        }
        .alert("Couldn't save your favorites. Please try again.", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        }
    }

    // MARK: - Header

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

    // MARK: - Sport Card

    private func sportCard(sport: Sport, sex: Sex) -> some View {
        let team = FavoriteTeam(sport: sport.description, gender: sex.filterDescription)
        let isSelected = viewModel.isSelected(team)
        return Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                viewModel.toggle(team)
            }
        } label: {
            VStack(spacing: 8) {
                ZStack(alignment: .topLeading) {
                    Image(sport.iconName)
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
                    Text(sport.description)
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.primary_gray)
                        .multilineTextAlignment(.center)
                    HStack(spacing: 4) {
                        Text(sex.symbol)
                            .font(Constants.Fonts.medium14)
                            .foregroundStyle(Constants.Colors.primary_gray)
                            .padding(4)
                            .background(Constants.Colors.gray_border)
                            .clipShape(Circle())
                        Text(sex.letter)
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
                Task {
                    if await viewModel.saveFavorites() {
                        onDone?()
                    }
                }
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
    
    // MARK: Helper
    
    private struct SportCard: Identifiable {
        let sport: Sport
        let sex: Sex
        var id: String { "\(sport.rawValue)-\(sex)" }
    }
}

#Preview {
    EditFavSportsView()
}

