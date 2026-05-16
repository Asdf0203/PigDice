//
//  Algorithms.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/9.
//  Updated for 1 & 2 Dice Compatibility
//

import Foundation

/// 難度：⭐ (純隨機)
/// 邏輯：看心情，50% 機率繼續擲，50% 機率停手。完全不管骰子數量或分數。
func shouldRollLevel1() -> Bool {
    return Bool.random()
}

/// 難度：⭐⭐ (穩紮穩打型)
/// 邏輯：加入必勝判斷，並根據骰子數量給予固定的數學期望值停手門檻。
func shouldRollLevel2(
    myScore: Int,
    turnScore: Int,
    diceAmount: Int,
    targetScore: Int = 100
) -> Bool {
    if myScore + turnScore >= targetScore { return false }

    // 單骰期望門檻約 20 分，雙骰因爆牌率高，期望門檻下降至 18 分
    let threshold = (diceAmount == 1) ? 20 : 18
    return turnScore < threshold
}

/// 難度：⭐⭐⭐ (靈活應變型)
/// 邏輯：根據雙方分數的領先/落後狀態，動態微調基礎的期望門檻。
func shouldRollLevel3(
    myScore: Int,
    opponentScore: Int,
    turnScore: Int,
    diceAmount: Int,
    targetScore: Int = 100
) -> Bool {
    if myScore + turnScore >= targetScore { return false }

    var dynamicThreshold = (diceAmount == 1) ? 20 : 18
    let scoreDifference = opponentScore - myScore

    if scoreDifference > 30 {
        // 落後太多，必須拼一把
        dynamicThreshold += 10
    } else if scoreDifference < -30 {
        // 領先很多，保守行事
        dynamicThreshold -= 5
    } else if opponentScore >= 80 {
        // 對手快贏了，這回合不拼可能就沒機會了
        dynamicThreshold += 15
    }

    return turnScore < dynamicThreshold
}

/// 難度：⭐⭐⭐⭐ (高階風險控管)
/// 邏輯：結合終局施壓，以及根據骰子數量計算的風險係數遞減。
func shouldRollLevel4(
    myScore: Int,
    opponentScore: Int,
    turnScore: Int,
    diceAmount: Int,
    targetScore: Int = 100
) -> Bool {
    if myScore + turnScore >= targetScore { return false }

    // 1. 絕境反撲
    if opponentScore >= (targetScore - 15) && myScore < (targetScore - 30) {
        let desperateThreshold = (diceAmount == 1) ? 40 : 35
        return turnScore < desperateThreshold
    }

    // 2. 風險係數計算 (Risk Factor)
    // 基礎門檻：單骰較高，雙骰較低
    let baseThreshold = (diceAmount == 1) ? 25.0 : 20.0
    let riskFactor = Double(turnScore) / 100.0

    var adjustedThreshold = baseThreshold
    if opponentScore > myScore {
        adjustedThreshold += 5.0  // 落後時容忍度提升
    } else {
        adjustedThreshold -= 5.0  // 領先時更保守
    }

    // 3. 雙骰特殊風險迴避
    // 如果是雙骰，且自己總分已經很高，雙 1 歸零的代價極其慘重
    if diceAmount == 2 && myScore > 70 {
        adjustedThreshold -= 4.0
    }

    // 分數越高，門檻自動壓縮
    let finalThreshold = Int(adjustedThreshold - (riskFactor * 20.0))
    return turnScore < finalThreshold
}

/// 難度：⭐⭐⭐⭐⭐ (數學最佳解)
/// 邏輯：透過「價值疊代 (Value Iteration)」計算出每一種狀態下的精確獲勝機率。
/// 注意：因為 1 顆骰子與 2 顆骰子的機率矩陣完全不同，我們需要在初始化時決定，或者在計算時分開處理。

class OptimalPigSolver {
    let targetScore = 100
    let diceAmount: Int
    var winProbability: [[[Double]]]

    /// 初始化時傳入目前的遊戲模式 (1 顆或 2 顆骰子)
    init(diceAmount: Int) {
        self.diceAmount = diceAmount
        winProbability = Array(
            repeating: Array(
                repeating: Array(repeating: 0.0, count: 100),
                count: 100
            ),
            count: 100
        )
        let success = loadPolicyFromFile()
        if !success {
            // 2. 在「背景執行緒」進行價值疊代計算
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                calculateOptimalPolicy()
                savePolicyToFile()
            }
        }
    }

    func shouldRoll(myScore: Int, opponentScore: Int, turnScore: Int) -> Bool {
        if myScore + turnScore >= targetScore { return false }

        let pWinIfHold =
            1.0
            - getWinProb(my: opponentScore, opp: myScore + turnScore, turn: 0)
        var pWinIfRoll = 0.0

        if diceAmount == 1 {
            // 單骰機率計算
            let bustProbability = 1.0 / 6.0
            pWinIfRoll +=
                bustProbability
                * (1.0 - getWinProb(my: opponentScore, opp: myScore, turn: 0))

            for rollValue in 2...6 {
                let rollProb = 1.0 / 6.0
                pWinIfRoll +=
                    rollProb
                    * getWinProb(
                        my: myScore,
                        opp: opponentScore,
                        turn: turnScore + rollValue
                    )
            }

        } else {
            // 雙骰機率計算
            // 雙 1 (Snake Eyes): 總分與回合分歸零
            let snakeEyesProb = 1.0 / 36.0
            pWinIfRoll +=
                snakeEyesProb
                * (1.0 - getWinProb(my: opponentScore, opp: 0, turn: 0))

            // 單一顆 1: 回合分歸零，總分保留
            let singleOneProb = 10.0 / 36.0
            pWinIfRoll +=
                singleOneProb
                * (1.0 - getWinProb(my: opponentScore, opp: myScore, turn: 0))

            // 有效分數 (兩顆都不是 1)
            let validRollCombinations: [Int: Double] = [
                4: 1.0 / 36.0, 5: 2.0 / 36.0, 6: 3.0 / 36.0, 7: 4.0 / 36.0,
                8: 5.0 / 36.0, 9: 4.0 / 36.0, 10: 3.0 / 36.0, 11: 2.0 / 36.0,
                12: 1.0 / 36.0,
            ]
            for (rollValue, prob) in validRollCombinations {
                pWinIfRoll +=
                    prob
                    * getWinProb(
                        my: myScore,
                        opp: opponentScore,
                        turn: turnScore + rollValue
                    )
            }
        }

        return pWinIfRoll > pWinIfHold
    }

    private func getWinProb(my: Int, opp: Int, turn: Int) -> Double {
        if my + turn >= targetScore { return 1.0 }
        if opp >= targetScore { return 0.0 }
        return winProbability[my][opp][turn]
    }

    /// (內部訓練函數) 使用價值疊代法 (Value Iteration) 填滿 winProbability 矩陣
    /// 注意：由於要計算 100 x 100 x 100 = 1,000,000 種狀態，執行時可能會需要幾秒鐘的時間。
    /// 建議在遊戲載入或開局前先非同步 (非主執行緒) 呼叫此函數。
    func calculateOptimalPolicy() {
        var maxDifference: Double = 1.0
        let epsilon = 0.00001  // 收斂條件：當所有機率變動小於這個值時，視為計算完成
        var iterations = 0
        let maxIterations = 1000  // 避免無限迴圈的保險機制

        // 有效分數的機率表 (用於兩顆骰子)
        let validRollCombinations: [(roll: Int, prob: Double)] = [
            (4, 1.0 / 36.0), (5, 2.0 / 36.0), (6, 3.0 / 36.0), (7, 4.0 / 36.0),
            (8, 5.0 / 36.0), (9, 4.0 / 36.0), (10, 3.0 / 36.0),
            (11, 2.0 / 36.0), (12, 1.0 / 36.0),
        ]

        print("開始計算最佳決策矩陣 (骰子數量: \(diceAmount))...")

        // 不斷疊代更新勝率，直到機率不再變動
        while maxDifference > epsilon && iterations < maxIterations {
            maxDifference = 0.0

            // i: 我方分數, j: 對方分數, k: 當前回合累積的分數
            for i in 0..<targetScore {
                for j in 0..<targetScore {
                    // k 的最大值只需要算到 100 - i，因為加上去超過 100 就直接贏了
                    for k in 0..<(targetScore - i) {

                        let oldProb = winProbability[i][j][k]

                        // 1. 計算「停手 (Hold)」的勝率
                        // 停手後，對手的分數變成 j，我們總分變成 i + k，輪到對方行動。
                        let pWinIfHold =
                            1.0 - getWinProb(my: j, opp: i + k, turn: 0)

                        // 2. 計算「繼續擲 (Roll)」的勝率
                        var pWinIfRoll = 0.0

                        if diceAmount == 1 {
                            // --- 單顆骰子 ---
                            let bustProbability = 1.0 / 6.0
                            pWinIfRoll +=
                                bustProbability
                                * (1.0 - getWinProb(my: j, opp: i, turn: 0))

                            for rollValue in 2...6 {
                                let rollProb = 1.0 / 6.0
                                pWinIfRoll +=
                                    rollProb
                                    * getWinProb(
                                        my: i,
                                        opp: j,
                                        turn: k + rollValue
                                    )
                            }
                        } else {
                            // --- 兩顆骰子 ---
                            // 狀況 A：雙 1 (總分歸零)
                            let snakeEyesProb = 1.0 / 36.0
                            pWinIfRoll +=
                                snakeEyesProb
                                * (1.0 - getWinProb(my: j, opp: 0, turn: 0))

                            // 狀況 B：單顆 1 (回合歸零)
                            let singleOneProb = 10.0 / 36.0
                            pWinIfRoll +=
                                singleOneProb
                                * (1.0 - getWinProb(my: j, opp: i, turn: 0))

                            // 狀況 C：有效分數
                            for combo in validRollCombinations {
                                pWinIfRoll +=
                                    combo.prob
                                    * getWinProb(
                                        my: i,
                                        opp: j,
                                        turn: k + combo.roll
                                    )
                            }
                        }

                        // 3. 在這個狀態下，理性的玩家會選擇勝率較高的行動 (max)
                        let newProb = max(pWinIfHold, pWinIfRoll)
                        winProbability[i][j][k] = newProb

                        // 4. 計算誤差值，用於判斷是否收斂
                        let diff = abs(newProb - oldProb)
                        if diff > maxDifference {
                            maxDifference = diff
                        }
                    }
                }
            }
            iterations += 1
        }
        print("矩陣計算完成！共花了 \(iterations) 次疊代。")
    }

    // 取得 App 的 Documents 資料夾路徑
    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        // 根據骰子數量動態決定檔名
        return paths[0].appendingPathComponent("pig_policy_\(diceAmount).json")
    }

    /// 將計算好的矩陣存成 JSON 檔案
    func savePolicyToFile() {
        let url = getFileURL()
        do {
            let data = try JSONEncoder().encode(winProbability)
            try data.write(to: url)
            print("💾 矩陣已成功儲存至：\(url.path)")
        } catch {
            print("❌ 儲存失敗：\(error.localizedDescription)")
        }
    }

    /// 嘗試從檔案載入矩陣。如果成功回傳 true，失敗回傳 false。
    func loadPolicyFromFile() -> Bool {
        let url = getFileURL()
        do {
            let data = try Data(contentsOf: url)
            let loadedProbability = try JSONDecoder().decode(
                [[[Double]]].self,
                from: data
            )
            self.winProbability = loadedProbability
            print("📂 成功從檔案載入矩陣！不用重算了。")
            return true
        } catch {
            print("⚠️ 找不到檔案或讀取失敗，需要重新計算。")
            return false
        }
    }
}
