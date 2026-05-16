struct playerView: View {
    @Binding var dicePoint: Int
    @Binding var player1Point: Int
    @Binding var player2Point: Int
    var turn: Color
    @State var addOnPoint: Int = 0

    var body: some View {
        if addOnPoint != 0 {
            Text("+\(addOnPoint)")
                .font(.largeTitle.scaled(by: 2))
                .bold()
                .foregroundStyle(turn)
                .offset(y: 150)
                .onTapGesture {
                    player1Point += addOnPoint
                    addOnPoint = 0
                }
        }
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 360)
                .offset(y: 440)
            Circle()
                .fill(turn)
                .frame(width: 330)
                .offset(y: 440)

            Text("Roll!!!")
                .font(.largeTitle.scaled(by: 1.5))
                .bold()
                .foregroundStyle(.white)
                .offset(y: 360)
        }
        .onTapGesture {
            dicePoint = .random(in: 1...6)
            addOnPoint += dicePoint
        }
    }
}