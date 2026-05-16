//
//  GameView.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/12.
//
import SwiftUI

struct GameView: View {
    @Binding var gameFlow: GameFlowState

    @Environment(PigGame.self) var game

    var body: some View {
        ZStack {
            Color(red: 255 / 255, green: 192 / 255, blue: 203 / 255)
                .ignoresSafeArea()

            PlayerView()
                .blur(radius: game.isEnded ? 5 : 0)

            ForEach(game.players) { player in
                PointCounterView(player: player)
                    .offset(x: -180, y: 300)
                    .rotationEffect(player.position.rotation)
            }
            .blur(radius: game.isEnded ? 5 : 0)

            WinningView()
                .animation(.easeInOut) { content in
                    content.opacity(game.isEnded ? 1 : 0)
                }
            
        }
        .onChange(of: game.isEnded) { oldValue, newValue in
            if newValue {
                Task {
                    // 延遲 2 秒 (2 * 1,000,000,000 奈秒)
                    try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)

                    // 切回主線程更新 UI
                    await MainActor.run {
                        withAnimation {
                            gameFlow = .setupPlayerNumber
                        }
                        game.resetGame()
                    }
                }
            }
        }
    }
}
