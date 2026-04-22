//
//  PorovnuApp.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 02.02.2026.
//

import SwiftUI
import SwiftData

@main
struct PorovnuApp: App {
    private let assembler = DefaultAssembler.shared
    private var navigationCoordinator = NavigationCoordinator()

    var body: some Scene {
        WindowGroup {
            CustomTabBarView(assembler: assembler)
                .environment(navigationCoordinator)
        }
    }
}
