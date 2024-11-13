//
//  GameView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/15/24.
//

import SwiftUI

struct GameView : View {
    var game : Game
    
    var body : some View {
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
                
                // Game information
                VStack(alignment: .leading, spacing: 4) {
                    Text("Men's Football")
                        .font(Constants.Fonts.subheader)
                    Text("Cornell vs. " + game.opponent)
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
                
                // Countdown
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
                .padding(.top, 50)
            }
            .padding(.bottom, 25)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Game Details")
                    .font(.system(size: 27, weight: .regular))
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // TODO: Add action for back button
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
    GameView(game: Game.dummyData[7])
}
