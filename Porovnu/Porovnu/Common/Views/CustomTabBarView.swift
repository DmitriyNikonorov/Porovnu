//
//  CustomTabView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import SwiftUI

struct CustomTabBarView: View {
    
    @EnvironmentObject var navigationCoordiantor: NavigationCoordinator
    let tabs: [TabItem] = [.home, .profile]
    let assembler: DefaultAssembler

    @State var homeViewModel: HomeViewModel

    init(assembler: DefaultAssembler) {
        self.assembler = assembler
        _homeViewModel = .init(wrappedValue: assembler.resolve())
    }

    var body: some View {
        ZStack {
            Group {
                switch navigationCoordiantor.selectedTab {
                case .home:
                    NavigationStack(path: $navigationCoordiantor.homePath) {
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
                    .contentMargins(.bottom, 50, for: .scrollContent)

                case .profile:
                    NavigationStack(path: $navigationCoordiantor.profilePath) {
                        ProfileView()
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
                            isSelected: navigationCoordiantor.selectedTab == tab
                        ) {
                            withAnimation(.spring()) {
                                navigationCoordiantor.selectedTab = tab
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
