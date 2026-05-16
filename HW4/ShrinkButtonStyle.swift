//
//  ShrinkButtonStyle.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/9.
//
import SwiftUI

struct ShrinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // configuration.isPressed 是 SwiftUI 自動給我們的
            // 手指按下去時為 true，放開時為 false
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            // 自動套用動畫
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ShrinkButtonStyle {
    // 宣告一個靜態變數，回傳你自訂的 Style 實體
    static var shrink: ShrinkButtonStyle {
        ShrinkButtonStyle()
    }
}

struct PushDownButtonStyle: ButtonStyle {
    var color: Color = .indigo
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                // 使用自訂 Shape (這裡以 RoundedRectangle 為例)
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    // 根據按下狀態改變陰影的擴散範圍與垂直偏移
                    .shadow(
                        color: color.opacity(0.5),
                        radius: configuration.isPressed ? 0 : 5,
                        x: 0,
                        y: configuration.isPressed ? 0 : 5
                    )
            )
            // 當被按下時，整個按鈕往下位移，填補陰影原本的位置
            .offset(y: configuration.isPressed ? 5 : 0)
            // 稍微縮放增加手感 (選用)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            // 增加透明度回饋
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PushDownButtonStyle {
    // 宣告一個靜態變數，回傳你自訂的 Style 實體
    static var pushDown: PushDownButtonStyle {
        PushDownButtonStyle()
    }
}

struct ConcaveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                Capsule() // 你可以換成任何 Shape
                    .fill(
                        Color.gray.opacity(0.2)
                            // 根據狀態決定是外陰影(凸起)還是內陰影(凹陷)
                            .shadow(
                                configuration.isPressed ? .inner(color: .black.opacity(0.3), radius: 3, x: 2, y: 2) : .drop(color: .black.opacity(0.2), radius: 4, x: 4, y: 4)
                            )
                            .shadow(
                                configuration.isPressed ? .inner(color: .white, radius: 3, x: -2, y: -2) : .drop(color: .white, radius: 4, x: -4, y: -4)
                            )
                    )
            )
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ConcaveButtonStyle {
    // 宣告一個靜態變數，回傳你自訂的 Style 實體
    static var concave: ConcaveButtonStyle {
        ConcaveButtonStyle()
    }
}
