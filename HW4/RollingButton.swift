//
//  RollingButton.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/9.
//
import SwiftUI

struct RollingButton: View {
    @Environment(PigGame.self) var game

    var body: some View {
        Button {
            game.rollDice()
        } label: {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 360)
                Circle()
                    .fill(game.currentPlayer.color)
                    .frame(width: 330)

                Text("Roll!!!")
                    .font(.largeTitle.scaled(by: 1.5))
                    .bold()
                    .foregroundStyle(.white)
                    .offset(y: -90)
                    .rotationEffect(.degrees(-45))
            }
        }
        .disabled(game.currentPlayer.isComputer)
    }
}
