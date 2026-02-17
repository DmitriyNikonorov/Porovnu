//
//  ContentView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 02.02.2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {

    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    @State private var showLeftAlert: Bool = false
    @State private var showRightAlert: Bool = false

    @State var viewModel: HomeViewModel

    var body: some View {
        List {
            ForEach(viewModel.events) { event in
                EventCardView(event: event)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .onTapGesture {
                        Task {
                            guard let event = await viewModel.fetchModels(by: event.id) else {
                                return
                            }
                            navigationCoordinator.navigate(to:.eventDetails(event))
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                    withAnimation {
                                        viewModel.deleteModel(by: event.id)
                                    }
                            } label: {
                                Image(uiImage: AppImages.trash.sring, withColor: .red)
                            }
                            .tint(.clear)

                    }
            }
        }
        .contentMargins(.top, 24, for: .scrollContent)
        .background(Color.appColor(.backgroundSecondary))
        .listStyle(.plain)
        .foregroundStyle(Color.appColor(.backgroundSecondary))
        .navigationBar(
            for: .home(title: "Мероприятия"),
            trailingButtonAction: navigationCoordinator.goToCreateEvent
        )
        .onAppear {
            Task {
                await viewModel.fetchModels()
            }
        }
    }
}

//#Preview {
////    HomeView(viewModel: HomeViewModel(dataBaseManager: DataBaseManager.shared))
//}
