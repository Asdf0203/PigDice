struct GearButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                // 疊加空心的齒輪作為框線
                Image(systemName: "gearshape")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.black)
            }
        }
    }
}