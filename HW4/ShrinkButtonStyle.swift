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