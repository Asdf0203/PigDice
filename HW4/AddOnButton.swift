//
//  AddOnButton.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/9.
//
import SwiftUI

struct AddOnButton: View {
    @Environment(PigGame.self) var game
    @State private var isFlying: Bool = false

    var body: some View {

        Text("+\(game.addOnScore)")
            .font(.largeTitle.scaled(by: 2))
            .bold()
            .foregroundStyle(game.currentPlayer.color)
            .popEffect(trigger: game.addOnScore, scale: 1.5)
//            .onChange(of: game.addOnScore) { oldValue, newValue in
//                if newValue == 0 {
//                    guard !isFlying else { return }
//                    isFlying = true
//                }
//            }
            .onTapGesture {
                guard !isFlying, game.addOnScore > 0 else { return }
                fly()
            }
            .scaleEffect(isFlying ? 0 : 1)
            .rotationEffect(.degrees(isFlying ? -90 : 0))
            .offset(
                x: isFlying ? -180 : 0,
                y: isFlying ? 130 : 0
            )
            // 2. ✨ 核心魔法：只在「飛出去」時給動畫，「歸零」時給 nil (瞬間完成)
            .animation(
                isFlying ? .easeIn(duration: 0.25).speed(2) : nil,
                value: isFlying
            )
            .disabled(game.currentPlayer.isComputer)
    }

    private func fly() {
        isFlying = true

        Task {
            try? await Task.sleep(for: .seconds(0.2))

            await MainActor.run {
                isFlying = false  // 瞬間歸位
                game.addOn()  // 動畫跑完後，才真正執行外部傳進來的加分與換人邏輯
            }
        }
    }
}
