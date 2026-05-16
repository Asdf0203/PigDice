//
//  CartoonOutlineModifier.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/12.
//


import SwiftUI

// ==========================================
// 1. 核心工具：打造「白包色」卡通描邊效果
// ==========================================

// 針對文字的粗描邊 (利用多重陰影模擬，效果最像貼紙)
struct CartoonOutlineModifier: ViewModifier {
    var color: Color
    var outlineColor: Color = .white
    var lineWidth: CGFloat = 3
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            // 利用四個方向的實心陰影模擬描邊
            .shadow(color: outlineColor, radius: 0, x: lineWidth, y: lineWidth)
            .shadow(color: outlineColor, radius: 0, x: -lineWidth, y: lineWidth)
            .shadow(color: outlineColor, radius: 0, x: lineWidth, y: -lineWidth)
            .shadow(color: outlineColor, radius: 0, x: -lineWidth, y: -lineWidth)
            // 再加一層淡淡的模糊陰影增加層次
            .shadow(color: outlineColor.opacity(0.5), radius: lineWidth)
    }
}

extension View {
    func cartoonStickerStyle(color: Color, outlineColor: Color = .white, lineWidth: CGFloat = 3) -> some View {
        self.modifier(CartoonOutlineModifier(color: color, outlineColor: outlineColor, lineWidth: lineWidth))
    }
}

// ==========================================
// 2. 自製卡通圖形 (取代醜的人像)
// ==========================================

// 簡單的卡通惡魔頭 (白包色風格)
struct CartoonDemonHead: View {
    var mainColor: Color
    var outlineColor: Color = .white
    var isShaking: Bool = false
    
    var body: some View {
        ZStack {
            // --- 1. 最底層的粗白色描邊層 (把所有形狀聯集後放大) ---
            Group {
                // 角
                HornShape()
                    .fill(outlineColor)
                    .offset(x: -20, y: -25)
                    .rotationEffect(.degrees(-15))
                HornShape()
                    .fill(outlineColor)
                    .offset(x: 20, y: -25)
                    .rotationEffect(.degrees(15))
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                
                // 主頭部
                RoundedRectangle(cornerRadius: 25)
                    .fill(outlineColor)
                    .frame(width: 70, height: 70)
            }
            .scaleEffect(1.15) // 整體放大作為描邊
            
            // --- 2. 中間的主顏色層 ---
            Group {
                // 角
                HornShape()
                    .fill(LinearGradient(colors: [mainColor.opacity(0.8), mainColor], startPoint: .top, endPoint: .bottom))
                    .offset(x: -20, y: -25)
                    .rotationEffect(.degrees(-15))
                HornShape()
                    .fill(LinearGradient(colors: [mainColor.opacity(0.8), mainColor], startPoint: .top, endPoint: .bottom))
                    .offset(x: 20, y: -25)
                    .rotationEffect(.degrees(15))
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                
                // 主頭部
                RoundedRectangle(cornerRadius: 20)
                    .fill(mainColor)
                    .frame(width: 60, height: 60)
                    // 卡通內陰影感
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black.opacity(0.2), lineWidth: 4)
                            .blur(radius: 2)
                            .offset(x: 2, y: 2)
                            .mask(RoundedRectangle(cornerRadius: 20))
                    )
            }
            
            // --- 3. 最上層的五官 (簡單幾何) ---
            VStack(spacing: 8) {
                // 眼睛
                HStack(spacing: 15) {
                    Circle().fill(outlineColor).frame(width: 12, height: 12)
                    Circle().fill(outlineColor).frame(width: 12, height: 12)
                }
                // 嘴巴 (邪惡微笑)
                Path { path in
                    path.addArc(center: CGPoint(x: 20, y: 10), radius: 20, startAngle: .degrees(20), endAngle: .degrees(160), clockwise: false)
                }
                .stroke(outlineColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 40, height: 15)
            }
            .offset(y: 5)
        }
        // 顫抖效果
        .offset(x: isShaking ? CGFloat.random(in: -2...2) : 0, y: isShaking ? CGFloat.random(in: -2...2) : 0)
    }
    
    // 角的形狀
    struct HornShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.maxX * 0.8, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY), control: CGPoint(x: rect.minX * 0.2, y: rect.midY))
            path.closeSubpath()
            return path
        }
    }
}

// ==========================================
// 3. 主視圖
// ==========================================

struct StickerEvilSlider: View {
    @Binding var level: Int
    
    // 數據定義
    let levels = [
        (name: "無害綠凍", color: Color(hex: "00E676")),
        (name: "搗蛋南瓜", color: Color(hex: "FF9100")),
        (name: "失控烈焰", color: Color(hex: "FF3D00")),
        (name: "劇毒暗影", color: Color(hex: "D500F9")),
        (name: "末日骷髏", color: Color(hex: "303F9F")),
        (name: "終極深淵", color: Color(hex: "1A1A1A")) // 接近黑
    ]
    
    var body: some View {
        GeometryReader { outerGeo in
            ZStack {
                // 背景：越難越黑，最高級變暗紅
                if level == 5 {
                    Color(hex: "1A0000").ignoresSafeArea() // 深暗紅背景
                } else {
                    Color.black.opacity(Double(level) * 0.15).ignoresSafeArea()
                }
                
                // 簡單背景裝飾：卡通泡泡
                ForEach(0..<10) { i in
                    Circle()
                        .fill(levels[level].color.opacity(0.1))
                        .frame(width: CGFloat.random(in: 20...100))
                        .position(x: CGFloat.random(in: 0...outerGeo.size.width), y: CGFloat.random(in: 0...outerGeo.size.height))
                        .animation(.easeInOut(duration: 2).repeatForever(), value: level)
                }
                
                HStack(spacing: 10) {
                    // ========== 左側：卡通貼紙文字區 ==========
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        
                        // 難度數字 (也是白包色)
                        Text("\(level + 1)")
                            .font(.system(size: 120, weight: .black, design: .rounded))
                            .cartoonStickerStyle(color: levels[level].color, lineWidth: 6)
                            .padding(.bottom, -20)
                        
                        // 難度名稱
                        Text(levels[level].name)
                            .font(.system(size: 36, weight: .heavy, design: .rounded))
                            .cartoonStickerStyle(color: levels[level].color, lineWidth: 4)
                            // 最高難度時劇烈顫抖
                            .offset(x: level == 5 ? CGFloat.random(in: -3...3) : 0, y: level == 5 ? CGFloat.random(in: -3...3) : 0)
                        
                        // 嘲諷文字
                        if level == 5 {
                            Text("這不是你該來的地方...")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(.top, 10)
                                .transition(.opacity)
                        }
                        
                        Spacer()
                    }
                    .frame(width: outerGeo.size.width * 0.55)
                    .padding(.leading, 20)
                    
                    // ========== 右側：卡通尺規區 ==========
                    GeometryReader { geo in
                        let sliderHeight = geo.size.height * 0.85
                        let stepHeight = sliderHeight / 5
                        let thumbSize: CGFloat = 90 // 惡魔頭大一點
                        
                        ZStack {
                            let centerX = geo.size.width * 0.5
                            
                            // 1. 卡通尺規軌道 (白包色)
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white) // 這是描邊層
                                    .frame(width: 45, height: sliderHeight + 15)
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(LinearGradient(colors: [Color(hex: "333333"), Color.black], startPoint: .top, endPoint: .bottom)) // 軌道內色
                                    .frame(width: 30, height: sliderHeight)
                            }
                            .position(x: centerX, y: geo.size.height / 2)
                            
                            // 2. 刻度 (卡通粗圓線)
                            ForEach(0...5, id: \.self) { i in
                                let yPos = (geo.size.height / 2 + sliderHeight / 2) - CGFloat(i) * stepHeight
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(i <= level ? levels[i].color : Color.gray)
                                    .frame(width: i == level ? 35 : 25, height: i == level ? 8 : 5)
                                    // 刻度也要白色描邊
                                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                                    .position(x: centerX, y: yPos)
                                    .animation(.spring(), value: level)
                            }
                            
                            // 3. 滑塊 (自製卡通惡魔頭)
                            let thumbY = (geo.size.height / 2 + sliderHeight / 2) - CGFloat(level) * stepHeight
                            
                            CartoonDemonHead(
                                mainColor: levels[level].color,
                                outlineColor: .white,
                                isShaking: level == 5
                            )
                            .frame(width: thumbSize, height: thumbSize)
                            .position(x: centerX, y: thumbY)
                            // 加上符合主顏色的發光 (Glow)，增加邪惡感，但不破壞卡通感
                            .shadow(color: levels[level].color, radius: CGFloat(level * 3))
                            // 限制數值的彈簧動畫，造成吸附感
                            .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.6), value: level)
                            
                        }
                        // 手勢區域
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let sliderBottomY = geo.size.height / 2 + sliderHeight / 2
                                    let yOffset = sliderBottomY - value.location.y
                                    let rawLevel = Int(round(yOffset / stepHeight))
                                    let clampedLevel = min(max(rawLevel, 0), 5)
                                    
                                    if level != clampedLevel {
                                        level = clampedLevel
                                        // 每次切換刻度給予震動 (iOS 17+)
                                        #if os(iOS)
                                        let impact = UIImpactFeedbackGenerator(style: level >= 4 ? .heavy : .medium)
                                        impact.impactOccurred()
                                        #endif
                                    }
                                }
                        )
                    }
                    .frame(width: outerGeo.size.width * 0.35)
                }
            }
        }
    }
}

// 簡單的 Hex 顏色支援
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xF, int & 0xF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
