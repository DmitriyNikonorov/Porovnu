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

    let homeViewModel: HomeViewModel

    init(assembler: DefaultAssembler) {
        self.assembler = assembler
        homeViewModel = assembler.resolve()
    }

    var body: some View {
        ZStack {
            Group {
                switch navigationCoordinator.selectedTab {
                case .home:
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
                    .contentMargins(.bottom, 50, for: .scrollContent)

                case .profile:
                    NavigationStack(path: Bindable(navigationCoordinator).profilePath) {
                        ProfileView()
                            .environment(navigationCoordinator)
                    }
                    .contentMargins(.bottom, 50, for: .scrollContent)

                }
            }
            .transition(.opacity)

            /// TabBar
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
//                .padding(.horizontal, 16)
                .padding(.vertical, 6.0)
                .background(
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

                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.appColor(.grayBrand).opacity(0.3), lineWidth: 0.5)
                )
                .shadow(color: Color.appColor(.background).opacity(0.1), radius: 10, y: 2)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
