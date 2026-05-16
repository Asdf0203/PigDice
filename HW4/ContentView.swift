//
//  ContentView.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/5.
//

import SwiftUI

enum GameFlowState {
    case setupPlayerNumber  // 設定畫面 1：人數與難度
    case setupDifficulty  // 設定畫面 2：分數與骰子
    case playing  // 遊戲主畫面
}

struct ModeSelectionButton: View {
    @Environment(PigGame.self) var game
    let text: String
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 30)
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.blue)
                        .padding(10)
                }
                .overlay {
                    Text(text)
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                }
                .frame(width: 160, height: 70)
        }
    }
}

struct RuleText: View {
    @Environment(PigGame.self) var game
    var body: some View {
        @Bindable var gameSettings = game.gameSettings
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "circlebadge")
                    .font(.callout)
                Text("獲勝需要達到")
            }
            HStack {
                Color.clear.frame(height: 5)
                Stepper(value: $gameSettings.winningScore) {
                    TextField("100", value: $gameSettings.winningScore, format: .number)
                        .fixedSize()
                        .keyboardType(.numberPad)
                }
            }
            Color.clear.frame(height: 5)
            HStack {
                Image(systemName: "circlebadge")
                    .font(.callout)
                Text("點擊")
                Text("Roll!!!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                    //.rotationEffect(.degrees(-45))
                Text("丟骰子")
            }
            Color.clear.frame(height: 5)
            HStack {
                Image(systemName: "circlebadge")
                    .font(.callout)
                Text("一次丟")
                ZStack {
                    Image(systemName: "die.face.1")
                    Image(systemName: "checkmark")
                        .font(.largeTitle.scaled(by: 1.5))
                        .foregroundStyle(.red)
                        .opacity(game.gameSettings.diceAmount == 1 ? 1 : 0)
                }
                .onTapGesture {
                    game.gameSettings.diceAmount = 1
                }
                Text("/")
                ZStack {
                    HStack(spacing: 1) {
                        Image(systemName: "die.face.1")
                        Image(systemName: "die.face.1")
                    }
                    Image(systemName: "checkmark")
                        .font(.largeTitle.scaled(by: 1.5))
                        .foregroundStyle(.red)
                        .opacity(game.gameSettings.diceAmount == 2 ? 1 : 0)
                }
                .onTapGesture {
                    game.gameSettings.diceAmount = 2
                }
            }
            Color.clear.frame(height: 5)
            HStack {
                Image(systemName: "circlebadge")
                    .font(.callout)
                Text("點擊")
                Text("+5")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.blue)
                Text("保留分數")
            }
        }
    }
}

struct SetupPlayerNumberView: View {
    @Binding var gameFlow: GameFlowState
    @Environment(PigGame.self) var game

    var body: some View {
        @Bindable var gameSettings = game.gameSettings

        ZStack {
            Color(red: 255 / 255, green: 192 / 255, blue: 203 / 255)
                .ignoresSafeArea()
            VStack {
                Text("小豬骰子")
                    .font(.largeTitle.scaled(by: 2))
                    .bold()

                RuleText()
                    .font(.title)
                    .padding(50)
                    .background {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.white.opacity(0.4))
                            .stroke(.white, lineWidth: 3)
                            .padding(30)
                    }

                Spacer()
                HStack(spacing: 20) {
                    ModeSelectionButton(text: "單人模式") {
                        gameSettings.playerNumber = 1
                        gameFlow = .setupDifficulty
                    }
                    .buttonStyle(.shrink)

                    ModeSelectionButton(text: "雙人模式") {
                        gameSettings.playerNumber = 2
                        game.players = [
                            Player(color: .blue, position: .down),
                            Player(color: .red, position: .up),
                        ]
                        gameFlow = .playing
                    }
                    .buttonStyle(.shrink)
                }
            }
        }
    }
}

struct SetupDifficultyView: View {
    @Binding var gameFlow: GameFlowState
    @Environment(PigGame.self) var game
    
    // 定義每一階的顏色
    let difficultyColors: [Color] = [
        .green,
        .blue,
        .orange,
        .red,
        Color(red: 0.3, green: 0.0, blue: 0.5) // 深紫色
    ]
    
    // 定義邪惡圖示
    let difficultyIcons = ["leaf.fill", "figure.walk", "flame", "flame.fill", "bolt.fill"]

    var body: some View {
        @Bindable var gameSettings = game.gameSettings
        ZStack {
            Color(red: 255 / 255, green: 192 / 255, blue: 203 / 255)
                .ignoresSafeArea()
            
            difficultyColors[gameSettings.difficulty-1]
                .opacity(0.4)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("選擇難度：")
                    Image(systemName: difficultyIcons[gameSettings.difficulty-1])
                        .foregroundStyle(difficultyColors[gameSettings.difficulty-1])
                }
                    .font(.largeTitle.scaled(by: 1.5))
                    .bold()
                CustomStepSlider(value: Binding<Double>(
                    get: { Double(gameSettings.difficulty) },
                    set: { gameSettings.difficulty = Int($0) }
                ), range: 1...5, step: 1, color: difficultyColors[gameSettings.difficulty-1])
                .frame(width: 300)
            }
            
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ModeSelectionButton(text: "開始遊戲") {
                        game.players = [
                            Player(color: .blue, position: .down),
                            Player(
                                color: .red,
                                position: .up,
                                isComputer: true,
                                aiLevel: gameSettings.difficulty
                            ),
                        ]
                        gameFlow = .playing
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var gameFlow = GameFlowState.setupPlayerNumber

    var body: some View {
        switch gameFlow {
        case .setupPlayerNumber:
            SetupPlayerNumberView(gameFlow: $gameFlow)
        case .setupDifficulty:
            SetupDifficultyView(gameFlow: $gameFlow)
        case .playing:
            GameView(gameFlow: $gameFlow)
        }
    }
}

#Preview {
    ContentView()
        .environment(PigGame())
}
