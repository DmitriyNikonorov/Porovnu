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
        ScrollView {
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
            .padding(.top, 16)
        }
        .contentMargins(.bottom, 52, for: .scrollContent) // FIXME: - вынести в глобальные константы
        .background(Color.appColor(.backgroundSecondary))
        .listStyle(.plain)
        .foregroundStyle(Color.appColor(.backgroundSecondary))
        .onAppear {
            viewModel.fetchModels()
        }
        .showToast(
            showToast: $showToast,
            content: createToast()
        )
        .navigationBar(
            model: NavigationBarModel(
                type: .home(title: Localized.EventsListView.events),
                trailingButtonAction: trailingButtonAction
            )
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
                title: Localized.EventsListView.deleted,
                message: Localized.EventsListView.eventDeleted
            )
        )
    }
}

