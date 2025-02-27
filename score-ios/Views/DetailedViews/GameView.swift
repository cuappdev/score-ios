//
//  GameView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/15/24.
//

import SwiftUI

struct GameView : View {
    var game : Game
    @State var viewState: Int = 0
    @State var dayFromNow: Int = 0
    @State var hourFromNow: Int = 0
    @State var minuteFromNow: Int = 0
    @Environment(\.presentationMode) var presentationMode
    // 0: hasn't started
    // 1: game started (no updates yet)
    // 2: game in progress / game finished
    
    private var numberOfRounds: Int {
        switch game.sport {
        case .Baseball: return 9
        case .Basketball, .Soccer, .Volleyball: return 2
        case .IceHockey: return 3
        case .FieldHockey, .Football, .Lacrosse, .SprintFootball: return 4
        default: return 1
        }
    }
    
    private var cornellTotalScore: Int {
        if game.timeUpdates.count == numberOfRounds {
            return game.timeUpdates.reduce(0, { $0 + $1.cornellScore }) // sum up the score for each round
        } else if game.timeUpdates.count == numberOfRounds + 1 {
            // the last one is the sum
            return game.timeUpdates[game.timeUpdates.count-1].cornellScore
        } else if game.timeUpdates.count > numberOfRounds {
            var scores = game.timeUpdates[0..<numberOfRounds]
            return scores.reduce(0, { $0 + $1.cornellScore }) // sum up the score for each round
        }
        else {
            return -1
        }
    }
    
    private var opponentTotalScore: Int {
        if game.timeUpdates.count == numberOfRounds {
            return game.timeUpdates.reduce(0, { $0 + $1.opponentScore })
        } else if game.timeUpdates.count == numberOfRounds + 1 {
            // the last one is the sum
            return game.timeUpdates[game.timeUpdates.count-1].opponentScore
        } else if game.timeUpdates.count > numberOfRounds {
            var scores = game.timeUpdates[0..<numberOfRounds]
            return scores.reduce(0, { $0 + $1.opponentScore }) // sum up the score for each round
        } else {
            return -1
        }
    }
    
    var body : some View {
        NavigationView {
            ZStack {
                switch viewState {
                    case 0: hasntStartedView
                    case 1: gameStartedView
                    case 2: gameInProgressView
                    default: hasntStartedView
                }
            }
            .onAppear { computeTimeFromNow() }
            .onAppear { updateViewState() }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Game Details")
                    .font(Constants.Fonts.h1)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("arrow_back_ios")
                            .resizable()
                            .frame(width: 9.87, height: 18.57)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

// MARK: Functions
extension GameView {
    private func computeTimeFromNow() {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: now, to: game.date)
        // Extract the values safely
        self.dayFromNow = components.day ?? 0
        self.hourFromNow = components.hour ?? 0
        self.minuteFromNow = components.minute ?? 0
    }
    
    private func updateViewState() {
        let now = Date()
        if (game.timeUpdates.isEmpty) {
            if (game.date <= now) {
                // game started but no score updates available
                self.viewState = 1
            } else {
                // game hasn't started
                self.viewState = 0
            }
        } else {
            // game score updates available
            self.viewState = 2
        }
    }
}

// MARK: Components
extension GameView {
    private var banner: some View {
        HStack {
            Spacer()
            Image("Cornell")
                .resizable()
                .frame(width: 72, height: 72)
            Spacer()
            Text("\(cornellTotalScore) - \(opponentTotalScore)")
                .font(Constants.Fonts.bold40)
                .foregroundColor(Constants.Colors.white)
            Spacer()
            AsyncImage(url: URL(string: game.opponent.image)) {
                image in
                image.image?.resizable()
            }
            .frame(width: 72, height: 72)
            
            Spacer()
        }
        .padding()
        .frame(height: 185)
        .background(LinearGradient(gradient: Gradient(colors: [
            Color(red: 179 / 255, green: 27 / 255, blue: 27 / 255, opacity: 0.4),
            Color(red: 1 / 255, green: 31 / 255, blue: 91 / 255, opacity: 0.4)
        ]), startPoint: .leading, endPoint: .trailing))
    }
    
    private var gameInfo: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(game.sex.description) \(game.sport.description)")
                    .font(Constants.Fonts.subheader)
                Text("Cornell vs. " + game.opponent.name)
                    .font(Constants.Fonts.header)
                
                HStack(spacing: 10) {
                    HStack {
                        Image("Location-g")
                            .resizable()
                            .frame(width: 13, height: 19)
                        Text(game.address)
                    }
                    
                    HStack {
                        Image("Alarm")
                        Text(Date.dateToString(date: game.date))
                    }
                }
                .font(Constants.Fonts.gameDate)
                .foregroundColor(.gray)
                .padding(.top, 10)
            }
            Spacer()
        }
    }
    
    private var countdown: some View {
        VStack {
            VStack {
                Image("Hourglass")
                    .resizable()
                    .frame(width: 93, height: 118)
                Text("Time Until Start")
                    .font(Constants.Fonts.h2)
                    .padding(.top, 24)
                
                HStack {
                    Text(String(dayFromNow))
                        .font(Constants.Fonts.countdownNum)
                    Text("days")
                        .font(Constants.Fonts.gameText)
                    Text(String(hourFromNow))
                        .font(Constants.Fonts.countdownNum)
                    Text("hours")
                        .font(Constants.Fonts.gameText)
                    Text(String(minuteFromNow))
                        .font(Constants.Fonts.countdownNum)
                    Text("minutes")
                }
                .padding(.top, 8)
            }
            .padding(.top, 20)
            
            
            // Calendar Button
            Button(action: {
                // TODO: action
            }) {
                HStack {
                    Image("Calendar")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Add to Calendar")
                        .font(Constants.Fonts.buttonLabel)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Constants.Colors.primary_red
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                        .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 30)) // Clip to shape to ensure rounded corners
            }
            .padding(.top, 68)
        }
    }
    
    private var summaryTab: some View {
        NavigationLink(destination: ScoringSummary(game: game)) {
            HStack {
                Text("Score Summary")
                    .font(Constants.Fonts.medium18)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Image("Right-arrow")
                    .resizable()
                    .frame(width: 9.87, height: 18.57)
            }
        }
    }
    
    private var gameSummary: some View {
        VStack {
            ForEach(Array(game.gameUpdates.prefix(3)).indices, id: \.self) { i in
                if game.gameUpdates[i].isCornell {
                    ScoringUpdateCell(update: game.gameUpdates[i], img: "Cornell")
                } else {
                    ScoringUpdateCell(update: game.gameUpdates[i], img: game.opponent.image)
                }
                
                // Add a divider except after the last cell
                if i < game.gameUpdates.prefix(3).count - 1 {
                    Divider()
                }
            }
        }
    }
    
    private var noGameSummary: some View {
        VStack {
            Image("speaker")
                .resizable()
                .frame(width: 90, height: 90)
                .padding(.top, 15)
            
            Text("No Scores Yet.")
                .font(Constants.Fonts.medium18)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Check back here later!")
                .font(Constants.Fonts.regular14)
                .foregroundStyle(Constants.Colors.gray_text)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var hasntStartedView: some View {
        VStack {
            // Banner
            banner
            Spacer()
            // Game information
            gameInfo
                .padding(.leading, 24)
                .padding(.trailing, 24)
                .padding(.top, 24)
            
            // Countdown
            countdown
                .padding(.bottom, 36)
        }
    }
    
    private var gameStartedView: some View {
        GeometryReader { geometry in
            VStack {
                banner
                gameInfo
                    .padding(.leading, 24)
                    .padding(.top, 24)
                
                VStack {
                    DynamicScoreBox(game: game)
                    
                    summaryTab
                        .padding(.top, 24)
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                .padding(.top, 24)
                
                gameSummary
                    .overlay {
                        if (game.gameUpdates.count < 3) {
                            noGameSummary
                                .padding(.top, 150)
                                .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
        }
        
    }
    
    private var gameInProgressView: some View {
        GeometryReader { geometry in
            VStack {
                banner
                Spacer()
                gameInfo
                    .padding(.leading, 24)
                    .padding(.top, 24)
                
                VStack {
                    DynamicScoreBox(game: game)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    summaryTab
                        .padding(.top, 24)
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                .padding(.top, 24)
                
                gameSummary
            }
        }
    }
    
    
}

#Preview {
    GameView(game: Game.dummyData[0])
}
