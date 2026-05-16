//
//  GameStatus.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/9.
//

import SwiftUI

@Observable
class PigGame {
    var gameSettings = GameSettings()
    var players: [Player] = []
    var currentPlayerIndex: Int = 0
    var currentPlayer: Player {
        players[currentPlayerIndex]
    }
    var dice1Point: Int = 1
    var dice2Point: Int = 1
    var totalDicePoint: Int {
        dice1Point + dice2Point
    }
    var addOnScore: Int = 0
    var isEnded: Bool = false
    
    let oneDiceSolver = OptimalPigSolver(diceAmount: 1)
    let twoDiceSolver = OptimalPigSolver(diceAmount: 2)

    func rollDice() {
        if gameSettings.diceAmount == 1 {
            roll1Dice()
        } else {
            roll2Dice()
        }
    }

    func roll1Dice() {
        dice1Point = .random(in: 1...6)

        if dice1Point == 1 {
            nextPlayer()
            return
        }

        addOnScore += dice1Point

        if addOnScore + currentPlayer.point >= gameSettings.winningScore {
            isEnded = true
            return
        }

        if currentPlayer.isComputer {
            executeAITurn()
        }
    }

    func roll2Dice() {
        dice1Point = .random(in: 1...6)
        dice2Point = .random(in: 1...6)

        if dice1Point == 1 && dice2Point == 1 {
            currentPlayer.point = 0
            nextPlayer()
            return
        }

        if dice1Point == 1 || dice2Point == 1 {
            nextPlayer()
            return
        }

        addOnScore += totalDicePoint

        if addOnScore + currentPlayer.point >= gameSettings.winningScore {
            isEnded = true
            return
        }

        if currentPlayer.isComputer {
            executeAITurn()
        }
    }

    func addOn() {
        currentPlayer.point += addOnScore
        addOnScore = 0
        nextPlayer()
    }

    func nextPlayer() {
        let nextIndex = currentPlayerIndex + 1
        currentPlayerIndex = players.indices.contains(nextIndex) ? nextIndex : 0
        addOnScore = 0

        if currentPlayer.isComputer {
            executeAITurn()
        }
    }

    func getOpponentScore() -> Int {
        var highestScore = 0
        for player in players {
            if player.point > highestScore {
                if player == currentPlayer {
                    break
                }
                highestScore = player.point
            }
        }
        return highestScore
    }

    func executeAITurn() {
        // 確保遊戲還沒結束，且當前玩家真的是電腦
        //guard !isEnded, currentPlayer.isComputer else { return }

        // 加上一點延遲（例如 1.2 秒），讓玩家能看清楚電腦的動作，不會一閃而過
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [self] in
            // 再次確認狀態，避免延遲期間遊戲被重置
            //guard !isEnded, currentPlayer.isComputer else { return }

            if addOnScore == 0 {
                rollDice()
                return
            }

            let myScore = currentPlayer.point
            let oppScore = getOpponentScore()
            let turnScore = addOnScore
            let targetScore = gameSettings.winningScore

            // 根據 AI 等級選擇演算法
            var shouldRoll = false
            switch currentPlayer.aiLevel {
            case 1:
                shouldRoll = shouldRollLevel1()
            case 2:
                shouldRoll = shouldRollLevel2(
                    myScore: myScore,
                    turnScore: addOnScore,
                    diceAmount: gameSettings.diceAmount,
                    targetScore: targetScore
                )
            case 3:
                shouldRoll = shouldRollLevel3(
                    myScore: myScore,
                    opponentScore: oppScore,
                    turnScore: turnScore,
                    diceAmount: gameSettings.diceAmount,
                    targetScore: targetScore
                )
            case 4:
                shouldRoll = shouldRollLevel4(
                    myScore: myScore,
                    opponentScore: oppScore,
                    turnScore: turnScore,
                    diceAmount: gameSettings.diceAmount,
                    targetScore: targetScore
                )
            case 5:
                if gameSettings.diceAmount == 1 {
                    shouldRoll = oneDiceSolver.shouldRoll(
                        myScore: myScore,
                        opponentScore: oppScore,
                        turnScore: turnScore)
                } else {
                    shouldRoll = twoDiceSolver.shouldRoll(
                        myScore: myScore,
                        opponentScore: oppScore,
                        turnScore: turnScore)
                }
            default:
                shouldRoll = shouldRollLevel1()
            }

            // 執行決策
            if shouldRoll {
                rollDice()  // 模擬按下「繼續擲」
            } else {
                addOn()  // 模擬按下「停手結算」
            }
        }
    }

    func resetGame() {
        addOnScore = 0
        currentPlayerIndex = 0
        for player in players {
            player.point = 0
        }
        isEnded = false
    }
}
