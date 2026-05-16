//
//  SettingView.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/9.
//
import SwiftUI

struct SettingView: View {
    @Binding var isSettingOn: Bool
    
    @Environment(PigGame.self) var game
    
    var body: some View {
        @Bindable var gameSettings = game.gameSettings
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)

            VStack(alignment: .leading) {
                Color.clear.frame(height: 10)
                Text("Settings")
                    .font(.largeTitle)
                Text("Player Number")
                    .frame(alignment: .leading)
                HStack {
                    IntSlider(value: $gameSettings.playerNumber, range: 1...2)
                    Text("\(gameSettings.playerNumber)")
                }
                Text("Difficulty")
                HStack {
                    IntSlider(value: $gameSettings.difficulty, range: 1...6)
                    Text("\(gameSettings.difficulty)")
                }
                Text("Winning Point")
                HStack {
                    IntSlider(
                        value: $gameSettings.winningScore,
                        range: 10...1000
                    )
                    Text("\(gameSettings.winningScore)")
                }
                Text("Dice Amount")
                HStack {
                    IntSlider(value: $gameSettings.diceAmount, range: 1...2)
                    Text("\(gameSettings.diceAmount)")
                }
                Spacer()
            }
            .padding(20)

            Button {
                isSettingOn = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.gray)
                    .frame(width: 40)
            }
            .offset(x: 120, y: -310)
        }
        .frame(width: 320, height: 700)
    }
}
