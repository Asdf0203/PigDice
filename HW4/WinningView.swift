//
//  WinningView.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/14.
//
import SwiftUI

struct WinningView: View {
    @Environment(PigGame.self) var game
    var body: some View {
        let winnerColor = game.currentPlayer.color
        winnerColor
            .opacity(0.8)
            .ignoresSafeArea()
        Text("\(String(describing: winnerColor).uppercased()) WINS")
            .font(.largeTitle.scaled(by: 2))
            .bold()
            .foregroundStyle(.white)
    }
}
