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
                    
                    // TODO: Fix dimension of logos
                    Image("penn_logo")
                        .resizable()
                        .frame(width: 72, height: 72)
                    Spacer()
                }
                .padding()
                .frame(height: 185)
                .background(LinearGradient(gradient: Gradient(colors: [
                    Color(red: 179 / 255, green: 27 / 255, blue: 27 / 255, opacity: 0.4),
                    Color(red: 1 / 255, green: 31 / 255, blue: 91 / 255, opacity: 0.4)
                ]), startPoint: .leading, endPoint: .trailing))
                
                // information
                VStack(alignment: .leading, spacing: 4) {
                    Text("Men's Football")
                        .font(Constants.Fonts.subheader)
                    Text("Cornell vs. " + game.opponent.rawValue)
                        .font(Constants.Fonts.header)
                    
                    HStack(spacing: 10) {
                        HStack {
                            Image("Alarm")
                            Text(Date.dateToString(date: game.date))
                        }
                        
                        // TODO: Fix location
                        HStack {
                            Image("Location-g")
                            Text("Ithaca (Schoellkopf)")
                        }
                    }
                    .font(Constants.Fonts.gameDate)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                }
                .padding()
                .padding(.trailing, 100)
                
                
                // score box
                VStack {
                    // first row
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
                    .background(Color(red: 179 / 255, green: 27 / 255, blue: 27 / 255))
                    
                    // second row
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
                    
                    // third row
                    HStack {
                        Text(game.opponent.rawValue)
                            .font(Constants.Fonts.gameText)
                            .foregroundStyle(.gray)
                            .frame(width: 60, alignment: .leading)
                            .padding(.leading, 8)
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
                .frame(maxWidth: .infinity)
                .background(Constants.Colors.white)
                .clipShape(RoundedRectangle(cornerRadius: 19))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Constants.Colors.gray_border, lineWidth: 1)
                        .shadow(radius: 5)
                )
                .padding(.leading, 24)
                .padding(.trailing, 24)
                
                // score summary tab
                Button {
                    // navigate to score summary view
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
                
                if (gameStarted) {
                    VStack {
                        ScoreSummaryTile(winner: "Cornell", time: "6:21", round: "1st Quarter", point: "Field Goal", score: "10 - 7")
                        ScoreSummaryTile(winner: "Penn", time: "8:40", round: "1st Quarter", point: "Touchdown", score: "7 - 7")
                        ScoreSummaryTile(winner: "Cornell", time: "11:29", round: "1st Quarter", point: "Touchdown", score: "7 - 0")
                    }
                } else {
                    // speaker
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
//            .padding(.top, 50)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Game Details")
                    .font(.system(size: 27, weight: .regular))
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Add action for back button
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
