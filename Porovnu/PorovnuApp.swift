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
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            EventModel.self,
//            ContributorModel.self,
//            SpendingModel.self,
//            HolderModel.self
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()


    private let assembler = DefaultAssembler.shared
    private var navigationCoordinator = NavigationCoordinator()

    var body: some Scene {
        WindowGroup {
            Group {
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
