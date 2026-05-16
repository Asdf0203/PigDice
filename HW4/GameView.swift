struct GameView: View {
    @State private var isSettingOn: Bool = false
    
    @Environment(PigGame.self) var game

    var body: some View {
        ZStack {
            Color(red: 255 / 255, green: 192 / 255, blue: 203 / 255)
                .ignoresSafeArea()

            Group {
                GearButton {
                    isSettingOn.toggle()
                }
                .frame(width: 100)
                .offset(x: 200)

                PlayerView()
                
                ForEach(game.players) { player in
                    PointCounterView(player: player)
                        .offset(x: -180, y: 300)
                        .rotationEffect(player.position.rotation)
                }

                SettingView(isSettingOn: $isSettingOn)
                .opacity(isSettingOn ? 1 : 0)
            }
            .blur(radius: game.isEnded ? 5 : 0)

            Group {
                Color.black.opacity(0.6).ignoresSafeArea()
                Text("YOu win!")
                    .font(.largeTitle.scaled(by: 2))
                    .bold()
                    .foregroundStyle(.white)
                Button("reset") {
                    game.resetGame()
                }
                .font(.largeTitle)
                .offset(y: 60)
            }
            .opacity(game.isEnded ? 1 : 0)
        }
    }

    
}