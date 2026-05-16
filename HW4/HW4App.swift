//
//  HW4App.swift
//  HW4
//
//  Created by 許哲浚 on 2026/5/5.
//

import SwiftUI

@main
struct HW4App: App {
    @State private var game = PigGame()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(game)
        }
    }
}
