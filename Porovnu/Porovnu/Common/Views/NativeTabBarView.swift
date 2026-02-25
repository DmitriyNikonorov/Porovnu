//
//  NativeTabView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import SwiftUI

@available(iOS 26.0, *)
struct NativeTabBarView: View {

    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    @State var homeViewModel: EditEventViewModel
    let assembler: DefaultAssembler

    init(assembler: DefaultAssembler) {
        self.assembler = assembler
        _homeViewModel = .init(wrappedValue: assembler.resolveEditEventViewModel(assembler: assembler))
        // Глобальная настройка цветов для TabView (iOS 26)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.appColor(.grayBrand))
        UITabBar.appearance().tintColor = UIColor(Color.appColor(.orangeBrand))
    }

    var body: some View {
        TabView(selection: Bindable(navigationCoordinator).selectedTab) {
            NavigationStack(path: Bindable(navigationCoordinator).homePath) {
                assembler.resolveEditEventView(viewModel: homeViewModel)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case let .eventDetails(event):
                            assembler.resolveEventView(
                                viewModel: assembler.resolveEventViewModel(
                                    event: event,
                                    assembler: assembler
                                )
                            )
                            .environment(navigationCoordinator)

                        case let .eventList(dto):
                            assembler.resolveEventsListView(
                                model: assembler.resolveEventsListViewModel(
                                    dto: dto
                                )
                            )
                            .environment(navigationCoordinator)

                        case let .editSpending(dto):
                            let spendingViewModel = assembler.resolveSpendingViewModel(
                                dto: dto
                            )
                            assembler.resolveSpendingView(viewModel: spendingViewModel)
                                .environment(navigationCoordinator)
                        }
                    }
            }
            .tabItem {
                tabItemView(for: .home)
            }
            .tag(TabItem.home)

            NavigationStack(path: Bindable(navigationCoordinator).profilePath) {
                ProfileView()
                    .environment(navigationCoordinator)
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
