//
//  diceView.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/9.
//
import SwiftUI

struct DiceView: View {
    @Environment(PigGame.self) var game
    @State private var animationTrigger = UUID()
    var body: some View {
        HStack {
            Image(systemName: "die.face.\(game.dice1Point)")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            if game.gameSettings.diceAmount == 2 {
                Image(systemName: "die.face.\(game.dice2Point)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
            }
        }
        .popEffect(trigger: animationTrigger, scale: 1.2)
        // 當分數增加（代表這是一次成功的投擲）時，觸發動畫
        // 如果 newValue 是 0，而且一/兩顆骰子都不是1，這裡會直接跳過，骰子就不會動
        .onChange(of: game.addOnScore) { oldValue, newValue in
            if newValue == 0 {
                if game.gameSettings.diceAmount == 1 {
                    if game.dice1Point != 1 {
                        return
                    }
                }
                if game.dice1Point != 1 && game.dice2Point != 1 {
                    return
                }
            }
            animationTrigger = UUID()
        }
    }
}
