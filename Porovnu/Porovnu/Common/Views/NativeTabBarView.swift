//
//  NativeTabView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import SwiftUI

@available(iOS 26.0, *)
struct NativeTabBarView: View {

    @EnvironmentObject var coordinator: NavigationCoordinator
    @State var homeViewModel: HomeViewModel
    let assembler: DefaultAssembler

    init(assembler: DefaultAssembler) {
        self.assembler = assembler
        _homeViewModel = .init(wrappedValue: assembler.resolve())
        // Глобальная настройка цветов для TabView (iOS 26)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.appColor(.grayBrand))
        UITabBar.appearance().tintColor = UIColor(Color.appColor(.orangeBrand))
    }

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.homePath) {
                assembler.resolveHomeView(model: homeViewModel)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .createEvent:
                            assembler.resolveCreateEventView()

                        case let .eventDetails(event):
                            assembler.resolveEventView(event: event)

                        case let .editEvent(event):
                            assembler.resolveEditEventView(event: event)
                        }
                    }
            }
            .tabItem {
                tabItemView(for: .home)
            }
            .tag(TabItem.home)

            NavigationStack(path: $coordinator.profilePath) {
                ProfileView()
//                    .navigationDestination(for: AppRoute.self) { route in
//                        switch route {
//                        case .createEvent:
//                            assembler.resolveCreateEventView()
//
//
//                        case .eventDetails(let event):
//                            EventView(event: event)
//                        }
//                    }
            }
            .tabItem {
                tabItemView(for: .profile)
            }
            .tag(TabItem.profile)
        }
        .tint(Color.appColor(.orangeBrand))
    }

    private func tabItemView(for tab: TabItem) -> some View {
        Label(tab.title, systemImage: tab.imageName)
    }
}
