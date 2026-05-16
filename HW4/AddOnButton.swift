struct AddOnButton: View {
    let point: Int
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("+\(point)")
                .font(.largeTitle.scaled(by: 2))
                .bold()
                .foregroundStyle(color)
                .phaseAnimator([1, 1.5, 1], trigger: point) { content, phase in
                    content
                        .scaleEffect(phase)
                } animation: { phase in
                    if phase == 1.5 {
                        // 準備放大的階段：極短的線性動畫，做出「瞬間變大」的感覺
                        .linear(duration: 0.01)
                    } else {
                        // 準備縮回的階段：用彈簧效果 (spring) ㄉㄨㄞ回去
                        // dampingFraction < blendDuration -> 會回彈
                        .spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)
                    }
                }

        }
    }
}