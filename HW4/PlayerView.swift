//
//  playerView.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/5.
//
import SwiftUI

struct PlayerView: View {
    @Environment(PigGame.self) var game
    
    var body: some View {
        ZStack {

            DiceView()
            
            AddOnButton()
                .offset(y: 150)
                .opacity(game.addOnScore == 0 ? 0 : 1)

            RollingButton()
                .buttonStyle(.shrink)
                .offset(x: 190, y: 400)
        }
        .rotationEffect(game.currentPlayer.position.rotation)
    }
}
