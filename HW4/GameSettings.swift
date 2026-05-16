//
//  GameSettings.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/7.
//

import SwiftUI

@Observable
class GameSettings {
    // Game Settings
    var playerNumber: Int = 1
    var difficulty: Int = 1
    var winningScore: Int = 10
    var diceAmount: Int = 1
}
