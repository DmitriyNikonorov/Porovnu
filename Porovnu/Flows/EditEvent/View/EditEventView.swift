//
//  EditEventView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 14.02.2026.
//

import SwiftUI

struct EditEventView: View {

    // MARK: - Private properties

    private let viewModel: EditEventViewModel
    @State private var keyboardHeight: CGFloat = 0

    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    @FocusState private var isFocused: Bool
    @State private var isAddButtonInListVisible = true
    @State private var showTopToast = false
    @State private var showInfoToast = false
    @State private var showBackNavigationAlert = false
    @State private var isDeleteMode: Bool = false
    @State private var isShowEditBarButton: Bool = true
    @State private var selectedPage: PagaIndicatorType = .spendings
    @State private var isKeyboardShow: Bool = false

    // MARK: - Init

    init(viewModel: EditEventViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            PageView(
                selectedType: $selectedPage,
                spendingsContent: {
                    ZStack {
                        scrollView()
                        if !isDeleteMode {
                            addContributorButtonFixed()
                        }
                    }
                },
                debtsContent: {
                    infoView()
                }
            )
            .ignoresSafeArea(.keyboard)
            .onChange(of: selectedPage) { _, newValue in
                switch newValue {
                case .spendings:
                    viewModel.isShowSaveBarButton = viewModel.isShowSaveBarButtonPreviousState

                case .debts:
                    isDeleteMode = false
                    viewModel.isShowSaveBarButton = false
                }

                isShowEditBarButton = newValue == .spendings
            }
        }
        .background(Color.appColor(.backgroundSecondary))
        .onAppear {
            viewModel.loadInitialEvent()
        }
        .showToast(
            showToast: $showTopToast,
            content: createToast()
        )
        .showToast(
            showToast: $showInfoToast,
            content: createInfoToast()
        )
        .alert(Localized.EditEventView.unsavedChangesTitle, isPresented: $showBackNavigationAlert) {
            Button(Localized.EditEventView.saveAndExit) {
                isDeleteMode = false
                navigateToEventListWithSave(true)
            }
            Button(Localized.EditEventView.exitWithoutSaving) {
                isDeleteMode = false
                navigateToEventListWithSave(false)
            }
            Button(Localized.EditEventView.stay, role: .cancel) {}
        } message: {
            Text(Localized.EditEventView.unsavedChangesMessage)
        }
        .navigationBar(
            model: NavigationBarModel(
                type: .editEvent(
                    title: selectedPage == .spendings
                    ? Localized.EditEventView.editing
                    : Localized.EditEventView.info
                ),
                leadingButtonAction: leadingButtonAction,
                trailingButtonAction: trailingButtonAction
            )
        )
    }
}

// MARK: - Private UI

private extension EditEventView {

    // MARK: - Spendings Tab

    func scrollView() -> some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                HStack {
                    CustomTextField(
                        placeholder: Localized.EditEventView.enterNamePlaceholder,
                        text: Bindable(viewModel).eventName,
                        type: .largeTitle,
                        isKeyboardShow: $isKeyboardShow
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.appColor(.backgroundSecondary).opacity(isDeleteMode ? 0.5 : 0))
                            .allowsHitTesting(isDeleteMode)
                    )
                }
                .padding(.top, 40)
                .padding(.bottom, 10)

                HStack {
                    Text(Localized.Common.contributors)
                        .foregroundStyle(Color.appColor(.textQuaternary))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                    Spacer()
                }

                ForEach(Bindable(viewModel).contributors.indices, id: \.self) { index in
                    HStack {
                        ContributorInfoView(
                            isFocused: $isFocused,
                            contributor: bindingForContributor(
                                at: index,
                                in: Bindable(viewModel).contributors
                            ),
                            isDeleteMode: $isDeleteMode,
                            isKeyboardShow: $isKeyboardShow,
                            placeholder: Localized.Common.contributor + "\((index) + 1)",
                            onAction: onAction
                        )
                        .padding(.vertical, 6)

                        if isDeleteMode {
                            Button {
                                onAction(
                                    action: .onDeleteContributor(viewModel.contributors[index].id)
                                )
                            } label: {
                                HStack(spacing: 4) {
                                    AppImages.trash.image
                                }
                                .foregroundStyle(Color.appColor(.red))
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .foregroundStyle(Color.appColor(.backgroundSecondary))

            /// Button
            addContributorButtonScrollable()
                .opacity(isDeleteMode ? 0 : 1)

        }
        .onChange(of: isKeyboardShow) { _, isKeyboardVisible in
            keyboardHeight = isKeyboardVisible ? 335 : 0
        }
        .contentMargins(.bottom, keyboardHeight, for: .scrollContent)
    }

    // MARK: - Add Button

    func addContributorButtonScrollable() -> some View {
        Button {
            withAnimation {
                viewModel.addContributor()
            }
        } label: {
            HStack {
                Spacer()
                AppImages.personBadgePlus.image
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(Color.appColor(.orangeBrand))
                Spacer()
            }
        }
        .scrollTargetLayout()
        .padding(.top, 16)
        .buttonStyle(PlainButtonStyle())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .visibilityTracker(
            isVisible: $isAddButtonInListVisible,
            coordinateSpace: СoordinateSpaceName.scrollViewName
        )
        .opacity(isAddButtonInListVisible ? 1 : 0)
        .disabled(!isAddButtonInListVisible)
    }

    func addContributorButtonFixed() -> some View {
        VStack {
            Spacer()
            Button {
                viewModel.addContributor()
            } label: {
                AppImages.personBadgePlus.image
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(Color.appColor(.orangeBrand))
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 48, height: 48)
            .padding(.bottom, 60)
            .opacity(isAddButtonInListVisible ? 0 : 1)
            .disabled(isAddButtonInListVisible)
        }
        .ignoresSafeArea(.keyboard)
    }

    // MARK: - Debts Tab

    func infoView() -> some View {
        ScrollView {
            if viewModel.hasAnyChanged {
                Text(Localized.EditEventView.dataWillUpdateAfterSaving)
                    .foregroundStyle(Color.appColor(.red))
                    .padding(.top, 40)
                    .padding(.horizontal)
            }
            if viewModel.noContributors {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 200)
                    Text(Localized.EditEventView.noContributorsPlaceholder)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.appColor(.textSecondary))
                        .padding(.horizontal)
                        .frame(maxHeight: .infinity, alignment: .center)
                    Spacer()
                        .frame(height: 200)
                }
            } else {
                HStack {
                    Text(Localized.Common.contributors)
                        .foregroundStyle(Color.appColor(.textQuaternary))
                        .padding(.top, viewModel.hasAnyChanged ? 12 : 40)
                        .padding(.bottom, 8)
                        .padding(.horizontal)
                    Spacer()
                }
                ForEach(viewModel.contributorTotalInfoList, id: \.id) { contributorTotalInfo in
                    /// Начало View
                    VStack(alignment: .leading) {
                        /// Заголовок блока
                        Text(contributorTotalInfo.name)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(Color.appColor(.orangeBrand))
                            .padding(.top, 12)
                            .padding(.bottom, 8)
                            .padding(.horizontal)
                        /// Расходы на всё мероприятие
                        VStack(spacing: 10) {
                            HStack {
                                Text(Localized.EditEventView.allExpenses)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(Color.appColor(.textSecondary))
                                    .padding(.leading, 8)
                                Spacer()
                                Text(String.amountString(contributorTotalInfo.totalSelfSpendings))
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(Color.appColor(.textSecondary))
                            }
                            .padding(.horizontal)
                            HStack {
                                Text(Localized.EditEventView.ownFunds)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(Color.appColor(.textSecondary))
                                    .padding(.leading, 8)
                                Spacer()
                                Text(String.amountString(contributorTotalInfo.selfSpendings))
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(Color.appColor(.textSecondary))
                            }
                            .padding(.horizontal)
                            HStack {
                                Text(Localized.EditEventView.inDebt)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(Color.appColor(.textSecondary))
                                    .padding(.leading, 8)
                                Spacer()
                                Text(String.amountString(contributorTotalInfo.totalDebt))
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(Color.appColor(.textSecondary))
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 0)
                                .fill(Color.appColor(.backgroundTertiary))
                        )

                        /// Заголовок блока "Получит от"
                        if contributorTotalInfo.spendings.isNotEmpty {
                            debtSpending(
                                title: Localized.EditEventView.willReceiveFrom,
                                items: contributorTotalInfo.spendings,
                                count: contributorTotalInfo.spendingsCount
                            )
                        }
                        /// Заголовок блока "Должен"
                        if contributorTotalInfo.debts.isNotEmpty {
                            debtSpending(
                                title: Localized.EditEventView.debtOwed,
                                items: contributorTotalInfo.debts,
                                count: contributorTotalInfo.debtsCount
                            )
                        }
                    }
                }
            }
        }
    }

    func debtSpending(title: String, items: [InfoItem], count: Double) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.appColor(.textSecondary))
                Spacer()
                Text(String.amountString(count))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.appColor(.textSecondary))
            }
            .padding(.top, 16)
            .padding(.horizontal)

            /// Долги
            VStack(spacing: 16) {
                ForEach(items, id:\.id) { item in
                    HStack {
                        Text(item.contributorName)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(Color.appColor(.textSecondary))
                        Spacer()
                        Text(String.amountString(item.amount))
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(Color.appColor(.textSecondary))
                    }
                    .padding(.horizontal)
                }
                .padding(.leading, 8)
            }
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.appColor(.backgroundTertiary))
            )
        }
    }

}

// MARK: - Private Methods

private extension EditEventView {
    var leadingButtonAction: NavigationBarButtonActionType {
        NavigationBarButtonActionType(
            firstAction: {
                guard viewModel.canGoBack else {
                    showBackNavigationAlert = true
                    return
                }
                isDeleteMode = false
                navigateToEventListWithSave(true)
            }
        )
    }

    var trailingButtonAction: NavigationBarButtonActionType {
        NavigationBarButtonActionType(
            firstAction: {
                withAnimation {
                    showTopToast.toggle()
                    viewModel.saveAllChanges()
                }
            },
            isShowFirstAction: Bindable(viewModel).isShowSaveBarButton,
            secondAction: {
                withAnimation {
                    isDeleteMode.toggle()
                }
            },
            isShowSecondAction: $isShowEditBarButton
        )
    }

    func navigateToEventListWithSave(_ withSave: Bool) {
        withSave ? viewModel.saveAllChanges() : viewModel.resetAllChanges()

        navigationCoordinator.navigate(
            to: .eventList(
                EventListDto(
                    onSelect: viewModel.setupEvent,
                    onCreateNew: viewModel.createNewEvent
                )
            )
        )
    }

    func onAction(action: EditViewAction) {
        switch action {
        case let .onDeleteSpending(spending, contributor):
            viewModel.deleteSpending(spending: spending, for: contributor)

        case let .onEditSpending(spending, contributor):
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

        case let .onCreateSpending(contributor):
            navigationCoordinator.navigate(
                to: .editSpending(
                    EditSpendingDto(
                        creditor: contributor,
                        spending: nil,
                        contributors: viewModel.contributors,
                        callback: { spending in
                            guard let spending else {
                                return
                            }

                            viewModel.saveSpending(spending, contributor: contributor)
                        }
                    )
                )
            )

        case let .onDeleteContributor(id):
            withAnimation {
                guard viewModel.canDeleteContributor else {
                    showInfoToast = true
                    return
                }
                viewModel.deleteContributor(at: id)
            }
        }
    }

    func createToast() -> some View {
        ToastView(
            showToast: $showTopToast,
            toastData: ToastView.ToastData(
                title: Localized.EditEventView.saved,
                message: Localized.EditEventView.changesSaved,
            )
        )
    }

    func createInfoToast() -> some View {
        ToastView(
            showToast: $showInfoToast,
            toastData: ToastView.ToastData(
                title: Localized.EditEventView.cannotDeleteContributor,
                message: Localized.EditEventView.atLeastOneContributorRequired
            )
        )
    }

    func bindingForContributor(at index: Int, in items: Binding<[Contributor]>) -> Binding<Contributor> {
        Binding(
            get: {
                guard index < items.wrappedValue.count else {
                    return Contributor(
                        id: UUID(),
                        name: String(),
                        spendings: []
                    )
                }
                return items.wrappedValue[index]
            },
            set: { newValue in
                guard index < items.wrappedValue.count else {
                    return
                }
                items.wrappedValue[index] = newValue
            }
        )
    }
}
