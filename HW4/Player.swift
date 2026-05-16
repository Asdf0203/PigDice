//
//  player.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/5.
//
import SwiftUI

enum PlayerPosition {
    case up
    case down

    var rotation: Angle {
        switch self {
        case .up:
            return .degrees(180)
        case .down:
            return .degrees(0)
        }
    }
}

@Observable
class Player: Identifiable, Equatable {
    
    let id = UUID()
    let color: Color
    let position: PlayerPosition
    
    let isComputer: Bool
    let aiLevel: Int

    var point: Int = 0

    init(color: Color, position: PlayerPosition, isComputer: Bool = false, aiLevel: Int = 4) {
        self.color = color
        self.position = position
        self.isComputer = isComputer
        self.aiLevel = aiLevel
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}
