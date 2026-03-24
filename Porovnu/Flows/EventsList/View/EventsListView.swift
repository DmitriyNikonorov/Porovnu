//
//  EventsListView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 02.02.2026.
//

import SwiftUI
import SwiftData

struct EventsListView: View {

    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    @State private var showLeftAlert: Bool = false
    @State private var showRightAlert: Bool = false
    @State private var showToast = false

    @State var viewModel: EventsListViewModel

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
                        guard let event = viewModel.fetchModels(by: event.id) else {
                            return
                        }
                        viewModel.onSelect(event.id)
                        navigationCoordinator.navigateBack()
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            withAnimation {
                                viewModel.deleteModel(by: event.id)
                                showToast.toggle()
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
            model: NavigationBarModel(
                type: .home(title: "Мероприятия"),
                trailingButtonAction: trailingButtonAction
            )
        )
        .onAppear {
            viewModel.fetchModels()
        }
        .showToast(
            showToast: $showToast,
            content: createToast()
        )
    }

    var trailingButtonAction: NavigationBarButtonActionType {
        NavigationBarButtonActionType(
            firstAction: {
                viewModel.onCreateNew()
                navigationCoordinator.navigateBack()
            }
        )
    }

    func createToast() -> some View {
        ToastView(
            showToast: $showToast,
            toastData: ToastView.ToastData(
                title: "Удалено",
                message: "Мероприятие удалено"
            )
        )
    }
}

