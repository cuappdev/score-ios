//
//  HomeView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/6/24.
//

import SwiftUI

struct HomeView: View {
    // State variables
    var paddingMain : CGFloat = 20
    @State private var selectedCardIndex: Int = 0
    @StateObject private var viewModel = GamesViewModel.shared
    
    // Main view
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                
                ZStack {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        carousel
                            .padding(.leading, paddingMain)
                            .padding(.trailing, paddingMain)
                        
                        Section(header: gameSectionHeader
                            .padding(.leading, paddingMain)
                            .padding(.trailing, paddingMain)) {
                                
                            // List of games
                            gameList
                                .padding(.leading, paddingMain)
                                .padding(.trailing, paddingMain)
                        }.background(Color.white)
                         .edgesIgnoringSafeArea(.top)
                    }
                    .safeAreaInset(edge: .bottom, content: {
                        Color.clear.frame(height: 20)
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onAppear {
            viewModel.fetchGames()
        }
        .onChange(of: viewModel.selectedSport) {
            viewModel.filter()
        }
        .onChange(of: viewModel.selectedSex) {
            viewModel.filter()
        }
    }
    
    private var gameSectionHeader: some View {
        VStack {
            VStack {
                Text("Game Schedule")
                    .font(Constants.Fonts.semibold24)
                    .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                
                genderSelector
                    .frame(maxWidth: .infinity, alignment: .center)
                sportSelector
            }
            .padding(.bottom, 16)
            
            Divider()
                .background(.clear)
        }
    }
    
}

// MARK: Components
extension HomeView {
    private var carousel: some View {
        VStack (alignment: .center) {
            Text("Upcoming")
                .font(Constants.Fonts.semibold24)
                .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                .padding(.top, 24)
            
            // Carousel
            TabView(selection: $selectedCardIndex) {
                ForEach(viewModel.topUpcomingGames.indices, id: \.self) { index in
                    UpcomingCard(game: viewModel.topUpcomingGames[index])
                        .tag(index)
                }
            }
            .frame(height: 220)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            // TODO: make this geometry reader only occur for iPhones with notches? Not sure, will need to check older phones
            GeometryReader { geometry in
                if geometry.frame(in: .global).minY > 30 {
                    HStack(spacing: 32) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(index == selectedCardIndex ? Constants.Colors.primary_red : Constants.Colors.unselected)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .position(x: geometry.frame(in: .local).midX)
                }
            }
        }
        .padding(.bottom, 24)
    }
    
    private var genderSelector: some View {
        PickerView(selectedSex: $viewModel.selectedSex, selectedIndex: viewModel.selectedSexIndex)
            .padding(.bottom, 12)
    }
    
    private var sportSelector: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Sport.allCases) { sport in
                    Button {
                        viewModel.selectedSport = sport
                    } label: {
                        FilterTile(sport: sport, selected: sport == viewModel.selectedSport)
                    }
                }
            }
        }
    }
    
    private var filters: some View {
        // Sex selector
        // TODO: full-width to fit the screen
        VStack {
            PickerView(selectedSex: $viewModel.selectedSex, selectedIndex: 0)
                .padding(.bottom, 12)
            
            // Sport selector
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Sport.allCases) { sport in
                        Button {
                            viewModel.selectedSport = sport
                        } label: {
                            FilterTile(sport: sport, selected: sport == viewModel.selectedSport)
                        }
                    }
                }
            }
            .padding(.bottom, 16)
        }
    }
    
    private var gameList: some View {
        LazyVStack(spacing: 16) {
            if viewModel.selectedUpcomingGames.isEmpty {
                NoGameView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ForEach(
                    viewModel.selectedUpcomingGames
                ) { game in
                    GeometryReader { cellGeometry in
                        let isCellCovered = cellGeometry.frame(in: .global).minY < 100
                        if !isCellCovered {
                            NavigationLink {
                                GameView(game: game)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                GameTile(game: game)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .frame(height: 96)
            }
        }
    }
}

#Preview {
    HomeView()
}
