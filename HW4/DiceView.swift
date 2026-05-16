struct diceView: View {
    let dicePoint: Int
    var body: some View {
        Image(systemName: "die.face.\(dicePoint)")
            .resizable()
            .scaledToFit()
            .frame(width: 150)
    }
}