//
//  GameDetailedScoreView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 10/16/24.
//

import SwiftUI

struct GameDetailedScoreView: View {
    var game: Game
    var gameStarted: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                // Banner
                banner
                
                VStack {
                    // information
                    information
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // score box
                    scoreBox
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                
                // score summary tab
                summaryTab
                
                // score summary
                if (gameStarted) {
                    gameSummary
                } else {
                    noGameSummary
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Game Details")
                        .font(Constants.Fonts.gameTitle)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // TODO: Add action for back button
                        ContentView()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    GameDetailedScoreView(game: Game.dummyData[7], gameStarted: true)
}

// MARK: Components
extension GameDetailedScoreView {
    private var banner: some View {
        HStack {
            Spacer()
            Image("Cornell")
                .resizable()
                .frame(width: 72, height: 72)
            Spacer()
            Text("0 - 0")
                .font(Constants.Fonts.title)
                .foregroundColor(.gray)
            Spacer()
            
            Image("penn_logo")
                .resizable()
                .frame(width: 72, height: 72)
            Spacer()
        }
        .padding()
        .frame(height: 185)
        .background(LinearGradient(gradient: Gradient(colors: [
            Constants.Colors.gradient_red,
            Constants.Colors.gradient_blue
        ]), startPoint: .leading, endPoint: .trailing))
    }
    
    private var information: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Men's Football")
                .font(Constants.Fonts.subheader)
            Text("Cornell vs. " + game.opponent.rawValue)
                .font(Constants.Fonts.header)
            
            HStack() {
                Image("Location-g")
                    .resizable()
                    .frame(width: 23, height: 26)
                Text("Ithaca (Schoellkopf)")
                Image("Alarm")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(Date.dateToString(date: game.date))
                
            }
            .font(Constants.Fonts.gameText)
            .foregroundColor(.gray)
            .padding(.top, 10)
        }
//        .padding(.leading, 24)
//        .padding(.trailing, 24)
        
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
            Text("-")
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
            Text("-")
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text("-")
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text("-")
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text("-")
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
            Text(game.opponent.rawValue)
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 60, alignment: .leading)
            Text("-")
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
            Text("-")
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text("-")
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text("-")
                .font(Constants.Fonts.gameText)
                .foregroundStyle(.gray)
                .frame(width: 24)
                .padding(.leading, 29.5)
            Text("-")
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
        VStack {
            firstRow
            secondRow
            thirdRow
        }
        .frame(maxWidth: .infinity)
        .background(Constants.Colors.white)
        .clipShape(RoundedRectangle(cornerRadius: 19))
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray_border, lineWidth: 1)
                .shadow(radius: 5)
        )
//        .padding(.leading, 24)
//        .padding(.trailing, 24)
    }
    
    private var summaryTab: some View {
        Button {
            // TODO: navigate to score summary view
        } label: {
            HStack {
                Text("Score Summary")
                    .font(Constants.Fonts.navBarTitle)
                    .foregroundStyle(.gray)
                Spacer()
                Image("Right-arrow")
                    .resizable()
                    .frame(width: 13, height: 10)
            }
            .padding(.leading, 15)
            .padding(.trailing, 17)
        }
    }
    
    private var gameSummary: some View {
        VStack {
            ScoreSummaryTile(winner: "Cornell", time: "6:21", round: "1st Quarter", point: "Field Goal", score: "10 - 7")
            ScoreSummaryTile(winner: "Penn", time: "8:40", round: "1st Quarter", point: "Touchdown", score: "7 - 7")
            ScoreSummaryTile(winner: "Cornell", time: "11:29", round: "1st Quarter", point: "Touchdown", score: "7 - 0")
        }
    }
    
    private var noGameSummary: some View {
        VStack {
            Image("speaker")
                .resizable()
                .frame(width: 90, height: 90)
            Text("Scores will be up soon.")
                .font(Constants.Fonts.caption)
                .foregroundStyle(Constants.Colors.gray_text)
        }
        .padding(.top, 40)
    }
}
