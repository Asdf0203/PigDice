struct SettingView: View {
    @Binding var isSettingOn: Bool
    @Bindable var gameSettings: GameSettings
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)

            VStack(alignment: .leading) {
                Color.clear.frame(height: 10)
                Text("Settings")
                    .font(.largeTitle)
                Text("Player Number")
                    .frame(alignment: .leading)
                HStack {
                    IntSlider(value: $gameSettings.playerNumber, range: 1...4)
                    Text("\(gameSettings.playerNumber)")
                }
                Text("Difficulty")
                HStack {
                    IntSlider(value: $gameSettings.difficulty, range: 1...2)
                    Text("\(gameSettings.difficulty)")
                }
                Text("Winning Point")
                HStack {
                    IntSlider(
                        value: $gameSettings.winningPoint,
                        range: 10...1000
                    )
                    Text("\(gameSettings.winningPoint)")
                }
                Text("Dice Amount")
                HStack {
                    IntSlider(value: $gameSettings.diceAmount, range: 1...4)
                    Text("\(gameSettings.diceAmount)")
                }
                Spacer()
            }
            .padding(20)

            Button {
                isSettingOn = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.gray)
                    .frame(width: 40)
            }
            .offset(x: 120, y: -310)
        }
        .frame(width: 320, height: 700)
    }
}