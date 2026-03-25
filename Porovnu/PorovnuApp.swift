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
            Group {
                //FIXME: - Раскоментить когда будет готов liquid glass
//                if #available(iOS 26.0, *) {
//                    NativeTabBarView(assembler: assembler)
//
//                } else {
                    CustomTabBarView(assembler: assembler)
//                }
            }
            .environment(navigationCoordinator)

        }
    }
}
