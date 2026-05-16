import SwiftUI

struct EvilRulerSlider: View {
    // 0 到 5，共 6 個刻度
    @State private var level: Int = 0
    
    // 定義每一階的難度標籤
    let difficultyLabels = ["新手散步", "微流汗", "有點挑戰", "痛苦邊緣", "極度折磨", "萬劫不復深淵"]
    
    // 定義每一階的顏色（越來越暗黑邪惡）
    let difficultyColors: [Color] = [
        .green,
        .mint,
        .yellow,
        .orange,
        .red,
        Color(red: 0.3, green: 0.0, blue: 0.5) // 深紫色
    ]
    
    // 定義邪惡圖示
    let difficultyIcons = ["leaf.fill", "figure.walk", "flame", "flame.fill", "bolt.fill", "skull"]
    
    var body: some View {
        ZStack {
            // 背景顏色：越難越黑，營造邪惡感
            Color.black
                .opacity(Double(level) * 0.15)
                .ignoresSafeArea()
            
            HStack(spacing: 30) {
                // ========== 左側：難度文字區 ==========
                VStack {
                    Spacer()
                    Text(difficultyLabels[level])
                        .font(.system(size: 28, weight: level >= 4 ? .black : .bold))
                        .foregroundColor(difficultyColors[level])
                        // 越難，文字的發光/陰影效果越強烈
                        .shadow(color: difficultyColors[level], radius: CGFloat(level * 3))
                        // 越難，字體稍微放大，給人壓迫感
                        .scaleEffect(1.0 + CGFloat(level) * 0.08)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: level)
                    
                    // 最高難度加點小提示
                    if level == 5 {
                        Text("放棄吧，這不是給人玩的")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 8)
                            .transition(.opacity)
                    }
                    Spacer()
                }
                .frame(width: 160)
                
                // ========== 右側：尺規滑桿區 ==========
                GeometryReader { geo in
                    let thumbSize: CGFloat = 60
                    let trackHeight = geo.size.height - thumbSize // 扣除滑塊高度，留出上下空間
                    let stepHeight = trackHeight / 5              // 5個區間，6個點
                    
                    ZStack(alignment: .top) {
                        // 1. 尺的軌道底色
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: trackHeight)
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        
                        // 2. 畫上 6 個刻度線
                        ForEach(0...5, id: \.self) { i in
                            // yPos 算法：i=5 是最上面(最高難度)，i=0 是最下面
                            let yPos = (thumbSize / 2) + CGFloat(5 - i) * stepHeight
                            
                            Rectangle()
                                .fill(i <= level ? difficultyColors[i] : Color.gray.opacity(0.5))
                                .frame(width: 24, height: 3)
                                .position(x: geo.size.width / 2 - 8, y: yPos) // 刻度偏左，像尺一樣
                        }
                        
                        // 3. 拖曳滑塊 (Thumb)
                        let thumbY = (thumbSize / 2) + CGFloat(5 - level) * stepHeight
                        
                        Circle()
                            .fill(difficultyColors[level])
                            .frame(width: thumbSize, height: thumbSize)
                            // 加上邪惡的發光效果，難度越高越亮
                            .shadow(color: difficultyColors[level], radius: CGFloat(level * 4))
                            .overlay(
                                Image(systemName: difficultyIcons[level])
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    // 骷髏頭加點跳動效果 (iOS 17+)
                                    .symbolEffect(.bounce, value: level)
                            )
                            .position(x: geo.size.width / 2, y: thumbY)
                            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.6), value: level)
                    }
                    // 將手勢綁定在整個軌道區域，不用精準按在球上也能滑
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // 計算手指所在的 Y 座標，換算成難度級別
                                let yOffset = value.location.y - (thumbSize / 2)
                                // 數值反轉：最上面 Y=0 是 Level 5，最下面是 Level 0
                                let rawLevel = 5 - Int(round(yOffset / stepHeight))
                                
                                // 限制數值在 0~5 之間
                                let clampedLevel = min(max(rawLevel, 0), 5)
                                
                                if level != clampedLevel {
                                    level = clampedLevel
                                }
                            }
                    )
                }
                .frame(width: 80)
                // 觸覺回饋：每次停在刻度上時，給予強烈的震動回饋 (iOS 17+)
                .sensoryFeedback(level >= 4 ? .impact(weight: .heavy, intensity: 1.0) : .selection, trigger: level)
            }
            .padding()
        }
    }
}

#Preview {
    EvilRulerSlider()
}