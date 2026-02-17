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
        TabView(selection: Bindable(navigationCoordinator).selectedTab) {
            NavigationStack(path: Bindable(navigationCoordinator).homePath) {
                assembler.resolveHomeView(model: homeViewModel)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .createEvent:
                            assembler.resolveCreateEventView()
                                .environment(navigationCoordinator)

                        case let .eventDetails(event):
                            assembler.resolveEventView(
                                viewModel: assembler.resolveEventViewModel(
                                    event: event,
                                    assembler: assembler
                                )
                            )
                            .environment(navigationCoordinator)

                        case let .editEvent(dto):
                            assembler.resolveEditEventView(
                                viewModel: assembler.resolveEditEventViewModel(
                                    dto: dto,
                                    assembler: assembler
                                )
                            )
                            .environment(navigationCoordinator)

//                        case let .editSpending(creditor, spending, contributors):
//
//                                let spendingViewModel = assembler.resolveSpendingViewModel(
//                                    creditor: creditor,
//                                    contributors: contributors,
//                                    spending: spending
//                                ) { spenging in
//                                    print("SAVE!!!")
//                                }
//                                assembler.resolveSpendingView(viewModel: spendingViewModel)
//                                .environment(navigationCoordinator)
                        case let .editSpending(dto):

//                                        let spendingViewModel = assembler.resolveSpendingViewModel(
//                                            creditor: creditor,
//                                            contributors: contributors,
//                                            spending: spending
//                                        ) { spenging in
//                                            print("SAVE!!!")
//                                        }

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
