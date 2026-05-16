struct PointCounterView: View {
    let color: Color
    let point: Int
    var body: some View {
        ZStack {
            Capsule()
                .fill(.white)
                .frame(width: 180, height: 80)
            Capsule()
                .fill(color)
                .frame(width: 160, height: 60)
            Text("\(point)")
                .font(.largeTitle.scaled(by: 1.3))
                .bold()
                .foregroundStyle(.white)
                .offset(x: 30)
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
                        .spring(
                            response: 0.3,
                            dampingFraction: 0.4,
                            blendDuration: 0.5
                        )
                    }
                }
        }
    }
}