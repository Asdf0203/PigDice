//
//  IntSlider.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/9.
//
import SwiftUI

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
        ) {
            
        }
    }
}

struct CustomStepSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let color: Color
    
    // 內部計算邏輯
    private func updateValue(at x: CGFloat, in totalWidth: CGFloat) {
        // 1. 計算百分比並限制在 0~1 之間
        let percent = max(0, min(1, Double(x / totalWidth)))
        
        // 2. 轉換為原始數值
        let newValue = range.lowerBound + percent * (range.upperBound - range.lowerBound)
        
        // 3. 核心：實現 Step 吸附邏輯
        let remainder = newValue.truncatingRemainder(dividingBy: step)
        var snapped = newValue - remainder
        if remainder > step / 2 {
            snapped += step
        }
        
        // 4. 更新綁定的值（確保不超出範圍）
        value = max(range.lowerBound, min(range.upperBound, snapped))
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width - 40
            let thumbX = width * CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
            
            ZStack(alignment: .leading) {
                // 1. 畫你的軌道 (Track)
                Capsule()
                    .fill(.white)
                    .frame(height: 50)
                    .overlay {
                        Capsule()
                            .fill(color)
                            .padding(8)
                    }
                
                // 2. 畫你的大頭針 (Thumb)
                Circle()
                    .fill(.white)
                    .shadow(radius: 4)
                    .frame(width: 70)
                    .overlay {
                        Circle()
                            .fill(color)
                            .padding(8)
                    }
                    .offset(x: thumbX) // 減去半徑讓中心對齊
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                updateValue(at: gesture.location.x, in: width)
                            }
                    )
            }
            .frame(maxHeight: .infinity)
        }
        .frame(height: 80)
    }
}
