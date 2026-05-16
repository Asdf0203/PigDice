//
//  PointCounterView.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/9.
//
import SwiftUI

struct PointCounterView: View {
    let player: Player
    var body: some View {
        ZStack {
            Capsule()
                .fill(.white)
                .frame(width: 180, height: 80)
            Capsule()
                .fill(player.color)
                .frame(width: 160, height: 60)
            Text("\(player.point)")
                .font(.largeTitle.scaled(by: 1.3))
                .bold()
                .foregroundStyle(.white)
                .fixedSize(horizontal: true, vertical: false)
                .popEffect(trigger: player.point, scale: 1.5)
                .offset(x: 30)
        }
    }
}
