//
//  EditEventView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 14.02.2026.
//

import SwiftUI

struct EditEventView: View {

    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    @FocusState private var isFocused: Bool
    private let viewModel: EditEventViewModel

    @State var selectSpending: Spending?
    @State var selectContributor: Contributor?
    @State private var showTopToast = false

    init(viewModel: EditEventViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                CustomTextField(
                    placeholder: "Введите название",
                    text: Bindable(viewModel).eventName,
                    isFocused: $isFocused,
                    type: .largeTitle
                )
                .padding(.horizontal)
                .padding(.vertical, 20.0)

                ForEach(Bindable(viewModel).contributors, id: \.id) { contributor in
                    ContributorInfoView(
                        isFocused: $isFocused,
                        contributor: contributor,
                        onAction: onAction
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                }
            }
            .foregroundStyle(Color.appColor(.backgroundSecondary))
            .showToast(
                showToast: $showTopToast,
                content: createToast()
            )
//            .alert("Внимание!", isPresented: Bindable(viewModel).showBackNavigationAlert) {
//                Button("Выйти без сохранения") {
//                    print("Нажали OK")
//                    navigationCoordinator.navigateBack()
//                }
//                Button("Остаться", role: .cancel) {
//                    print("Нажали Отмена")
//                }
//            } message: {
//                Text("Без сохранения все изменения будут потеряны")
//            }
            .navigationBar(
                for: .editEvent(title: "Список трат"),
                leadingButtonAction: {
                    viewModel.saveEvent()
                    navigationCoordinator.navigateBack()
//                    if viewModel.canGoBack() {
//                        navigationCoordinator.navigateBack()
//                    }
                },
                trailingButtonAction: {
                    withAnimation {
                        viewModel.saveEvent() ? showTopToast.toggle() : ()
                    }
                }
            )
        }
        .background(Color.appColor(.backgroundSecondary))
    }
}

private extension EditEventView {
    func onAction(action: EditViewAction) {
        switch action {
        case let .onDelete(spending, contributor):
            viewModel.deleteSpending(spending: spending, for: contributor)

        case let .onTap(spending, contributor):
            navigationCoordinator.navigate(
                to: .editSpending(
                    EditSpendingDto(
                        creditor: contributor,
                        spending: spending,
                        contributors: viewModel.contributors,
                        callback: { spending in
                            guard let spending else {
                                return
                            }
                            viewModel.updateSpending(spending, for: contributor)
                        }
                    )
                )
            )
        }
    }

    func createToast() -> some View {
        ToastView(
            showToast: $showTopToast,
            toastData: ToastView.ToastData(
                title: "Сохранено",
                message: "Внесенные изменения сохранены",
                backgroundColor: Color.appColor(.blueBrand)
            )
        )
    }
}
