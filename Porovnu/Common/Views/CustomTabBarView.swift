//
//  CustomTabView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import SwiftUI

struct CustomTabBarView: View {

    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    let tabs: [TabItem] = [.home, .profile]
    let assembler: DefaultAssembler
    let homeViewModel: EditEventViewModel

    init(assembler: DefaultAssembler) {
        self.assembler = assembler
        homeViewModel = assembler.resolveEditEventViewModel(assembler: assembler)
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        ZStack {
            TabView(selection: Bindable(navigationCoordinator).selectedTab) {
                NavigationStack(path: Bindable(navigationCoordinator).homePath) {
                    assembler.resolveEditEventView(viewModel: homeViewModel)
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
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
                        .ignoresSafeArea(edges: .bottom)
                }
                .tag(TabItem.home)

                NavigationStack(path: Bindable(navigationCoordinator).profilePath) {
                    ProfileView()
                        .environment(navigationCoordinator)
                        .ignoresSafeArea(edges: .bottom)
                }
                .tag(TabItem.profile)
            }
            .tabViewStyle(.sidebarAdaptable)

            /// TabBar
            CustomTabView(tabs: tabs)
                .environment(navigationCoordinator)
        }
        .onAppear {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
    }
}

struct CustomTabView: View {

    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    let tabs: [TabItem]


    var body: some View {
        VStack {
            Spacer()

            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { tab in
                    TabButton(
                        tab: tab,
                        isSelected: navigationCoordinator.selectedTab == tab
                    ) {
                        withAnimation(.spring()) {
                            navigationCoordinator.selectedTab = tab
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 6.0)
            .background {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 25)
                        .glassEffect(.regular)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.appColor(.backgroundTertiary).opacity(0.9),
                                            Color.appColor(.backgroundSecondary).opacity(0.95)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .blendMode(.difference)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.appColor(.backgroundTertiary).opacity(0.9),
                                    Color.appColor(.backgroundSecondary).opacity(0.95)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .blur(radius: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.appColor(.grayBrand).opacity(0.3), lineWidth: 0.5)
                        )
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
