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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            EventModel.self,
            ContributorModel.self,
            SpendingModel.self,
            HolderModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    private var navigationCoordinator = NavigationCoordinator()
    private let assembler = DefaultAssembler()

    var body: some Scene {
        WindowGroup {
            Group {
                if #available(iOS 26.0, *) {
                    NativeTabView(assembler: assembler)

                } else {
                    CustomTabView(assembler: assembler)
                }
            }
            .modelContainer(sharedModelContainer)
            .environmentObject(navigationCoordinator)
        }
    }
}
