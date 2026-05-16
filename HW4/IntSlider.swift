struct IntSlider: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    var step: Int = 1

    var body: some View {
        Slider(
            value: Binding<Double>(
                get: { Double(value) },
                set: { value = Int($0) }
            ),
            in: Double(range.lowerBound)...Double(range.upperBound),
            step: Double(step)
        )
    }
}