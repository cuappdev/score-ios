//
//  GameView.swift
//  score-ios
//
//  Created by Mac User on 9/15/24.
//

import SwiftUI

struct GameView : View {
    var game : Game
    @State var viewState: Int = 0
    @State var dayFromNow: Int = 0
    @State var hourFromNow: Int = 0
    @State var corScore1: String = "-"
    @State var corScore2: String = "-"
    @State var corScore3: String = "-"
    @State var corScore4: String = "-"
    @State var corScoreTotal: String = "0"
    @State var oppScore1: String = "-"
    @State var oppScore2: String = "-"
    @State var oppScore3: String = "-"
    @State var oppScore4: String = "-"
    @State var oppScoreTotal: String = "0"
    @Environment(\.presentationMode) var presentationMode
    // 0: hasn't started
    // 1: game started (no updates yet)
    // 2: game in progress / game finished

    
    var body : some View {
        NavigationView {
            ZStack {
                switch viewState {
                    case 0: hasntStartedView
                    case 1: gameStartedView
                    case 2: gameInProgressView
                        .onAppear { updateScores() }
                    default: hasntStartedView
                }
            }
            .onAppear { computeTimeFromNow() }
            .onAppear { updateViewState() }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Game Details")
                    .font(.system(size: 27, weight: .regular))
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
        let components = calendar.dateComponents([.day, .hour], from: now, to: game.date)
        // Extract the values safely
        self.dayFromNow = components.day ?? 0
        self.hourFromNow = components.hour ?? 0
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
    
    private func updateScores() {
        if (game.timeUpdates.count >= 2) {
            // scores for more than 4 rounds are available, display the first four rounds
            let timeUpdate1 = game.timeUpdates[0]
            corScore1 = String(timeUpdate1.cornellScore)
            oppScore1 = String(timeUpdate1.opponentScore)
        }
        
        if (game.timeUpdates.count >= 3) {
            // scores for more than 4 rounds are available, display the first four rounds
            let timeUpdate2 = game.timeUpdates[1]
            corScore2 = String(timeUpdate2.cornellScore)
            oppScore2 = String(timeUpdate2.opponentScore)
        } else {
            corScore3 = "-"
            corScore4 = "-"
            corScoreTotal = "-"
            oppScore3 = "-"
            oppScore4 = "-"
            oppScoreTotal = "-"
        }
        
        
        if (game.timeUpdates.count >= 4) {
            // scores for more than 4 rounds are available, display the first four rounds
            let timeUpdate3 = game.timeUpdates[2]
            corScore3 = String(timeUpdate3.cornellScore)
            oppScore3 = String(timeUpdate3.opponentScore)
        } else {
            corScore4 = "-"
            corScoreTotal = "-"
            oppScore4 = "-"
            oppScoreTotal = "-"
        }
        
        if (game.timeUpdates.count >= 5) {
            // scores for more than 4 rounds are available, display the first four rounds
            let timeUpdate4 = game.timeUpdates[3]
            corScore4 = String(timeUpdate4.cornellScore)
            oppScore4 = String(timeUpdate4.opponentScore)
            if (game.timeUpdates[game.timeUpdates.count - 1].isTotal) {
                let totalScores = game.timeUpdates[game.timeUpdates.count - 1]
                corScoreTotal = String(totalScores.cornellScore)
                oppScoreTotal = String(totalScores.opponentScore)
            } else {
                corScoreTotal = "-"
                oppScoreTotal = "-"
            }
        }
        
        // get total scores
        if (!game.gameUpdates.isEmpty) {
            corScoreTotal = String(game.gameUpdates[game.gameUpdates.count-1].cornellScore)
            oppScoreTotal = String(game.gameUpdates[game.gameUpdates.count-1].opponentScore)
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
            Text("\(corScoreTotal) - \(oppScoreTotal)")
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
    
    private var firstRow: some View {
        HStack {
            HStack{
                Text("1")
                    .font(Constants.Fonts.gameText)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                Text("2")
                    .font(Constants.Fonts.gameText)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                Text("3")
                    .font(Constants.Fonts.gameText)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                Text("4")
                    .font(Constants.Fonts.gameText)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                Text("Total")
                    .font(Constants.Fonts.gameText)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
            }
            .padding(.leading, 60)
            .padding(.trailing, 10)
        }
        .frame(height: 40)
        .background(Constants.Colors.primary_red)
    }
    
    private var secondRow: some View {
        HStack {
            Text("Cornell")
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 60, alignment: .leading)
            Text(corScore1)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
            Text(corScore2)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text(corScore3)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text(corScore4)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text(corScoreTotal)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
                .padding(.trailing, 12)
        }
        .frame(height: 40)
        .padding(.leading, 10)
    }
    
    private var thirdRow: some View {
        HStack {
            Text(game.opponent.name)
                .lineLimit(1)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 60, alignment: .leading)
            Text(oppScore1)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
            Text(oppScore2)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text(oppScore3)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text(oppScore4)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text(oppScoreTotal)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
                .padding(.trailing, 12)
        }
        .frame(height: 40)
        .padding(.leading, 10)
    }
    
    private var scoreBox: some View {
        VStack(spacing: 0) {
            firstRow
            secondRow
            Rectangle() // Custom red divider
                .fill(Constants.Colors.primary_red)
                .frame(height: 0.8)
            thirdRow
        }
        .frame(maxWidth: .infinity)
        .background(Constants.Colors.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Constants.Colors.primary_red, lineWidth: 1)
                .shadow(radius: 5)
        )
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
            .padding(.leading, 15)
            .padding(.trailing, 17)
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
            Text("No Scores Yet.")
                .font(Constants.Fonts.medium18)
            Text("Check back here later!")
                .font(Constants.Fonts.regular14)
                .foregroundStyle(Constants.Colors.gray_text)
        }
        .frame(maxWidth: .infinity)
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
        VStack {
            banner
            gameInfo
                .padding(.leading, 24)
                .padding(.top, 24)
            
            VStack {
                scoreBox
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
            .padding(.top, 24)
            
            // score summary tab
            summaryTab
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
    
    private var gameInProgressView: some View {
        VStack {
            banner
            Spacer()
            gameInfo
                .padding(.leading, 24)
                .padding(.top, 24)
            
            VStack {
                scoreBox
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
            .padding(.top, 24)
            
            // score summary tab
            summaryTab
                .padding(.top, 24)
            gameSummary
        }
    }
    
    
}

#Preview {
    GameView(game: Game.dummyData[0])
}

#Preview {
    GameView(game: Game.dummyData[7])
}
