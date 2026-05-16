//
//  popEffect.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/9.
//
import SwiftUI

struct PopEffect<T: Equatable>: ViewModifier {
    let trigger: T
    let scale: CGFloat
    let anchor: UnitPoint = .center
    
    func body(content: Content) -> some View {
        content
            .phaseAnimator([1, scale, 1], trigger: trigger) { content, phase in
                content
                    .scaleEffect(phase, anchor: anchor)
            } animation: { phase in
                if phase == scale {
                    // 準備放大的階段：極短的線性動畫，做出「瞬間變大」的感覺
                    .linear(duration: 0.01)
                } else {
                    // 準備縮回的階段：用彈簧效果 (spring) ㄉㄨㄞ回去
                    // dampingFraction < blendDuration -> 會回彈
                    .spring(
                        response: 0.3,
                        dampingFraction: 0.4,
                        blendDuration: 0.5
                    )
                }
            }
    }
}

extension View {
    /// 讓 View 在特定數值改變時，產生 Q 彈的放大縮小特效
    /// - Parameters:
    ///   - trigger: 觸發動畫的變數 (任何符合 Equatable 的型別)
    ///   - scale: 放大的最大倍率 (預設為 1.5 倍)
    func popEffect<T: Equatable>(trigger: T, scale: CGFloat = 1.5) -> some View {
        self.modifier(PopEffect(trigger: trigger, scale: scale))
    }
}
