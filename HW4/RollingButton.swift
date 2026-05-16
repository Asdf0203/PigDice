struct RollingButton: View {
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 360)
                Circle()
                    .fill(color)
                    .frame(width: 330)

                Text("Roll!!!")
                    .font(.largeTitle.scaled(by: 1.5))
                    .bold()
                    .foregroundStyle(.white)
                    .offset(y: -90)
                    .rotationEffect(.degrees(-45))
            }
        }
    }
}