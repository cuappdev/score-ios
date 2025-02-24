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
                
                // information
                information
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 24)
                    .padding(.trailing, 24)
                
                if (gameStarted) {
                    VStack {
                        scoreBox
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 24)
                    .padding(.trailing, 24)
                    
                    summaryTab
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 24)
                    .padding(.trailing, 24)
                    
                    // score summary
                    if (!game.timeUpdates.isEmpty) {
                        gameSummary
                    } else {
                        noGameSummary
                    }
                } else {
                    countDown
                        .padding(.top, 40)
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Game Details")
                        .font(Constants.Fonts.medium18)
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
                .foregroundColor(.white)
                .shadow(radius: 4)
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
                .font(Constants.Fonts.medium14)
            Text("Cornell vs. " + game.opponent.name)
                .font(Constants.Fonts.semibold24)
            
            HStack() {
                Image("Location-g")
                    .resizable()
                    .frame(width: 13, height: 19)
                Text("Ithaca (Schoellkopf)")
                Image("Alarm")
                    .resizable()
                    .frame(width: 19.78, height: 18.34)
                Text(Date.dateToString(date: game.date))
            }
            .font(Constants.Fonts.gameText)
            .foregroundColor(.gray)
            .padding(.top, 10)
        }
    }
    
    // countdown
    private var countDown: some View {
        VStack {
            Image("Hourglass")
                .resizable()
                .frame(width: 93, height: 118)
            
            Text("Time Until Start")
                .font(Constants.Fonts.h2)
                .padding(.top, 24)
            
            HStack {
                Text("2")
                    .font(Constants.Fonts.countdownNum)
                Text("days")
                    .font(Constants.Fonts.gameText)
                Text("0")
                    .font(Constants.Fonts.countdownNum)
                Text("hours")
                    .font(Constants.Fonts.gameText)
            }
            .padding(.top, 8)
            
            // Add to Calendar Button
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
                .frame(height: 48)
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
            .padding(.bottom, 36)
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
            Text(game.opponent.name)
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
        NavigationLink {
            ScoringSummary(game: game)
        } label: {
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
            Text("No Scores Yet.")
                .font(Constants.Fonts.medium18)
            Text("Check back here later!")
                .font(Constants.Fonts.regular14)
                .foregroundStyle(Constants.Colors.gray_text)
        }
        .padding(.top, 40)
        .padding(.bottom, 50)
    }
}
