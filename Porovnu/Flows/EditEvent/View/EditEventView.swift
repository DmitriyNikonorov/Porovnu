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
    private let coordinateSpaceName = "scrollView"

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
                        buttonStack()
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
        .alert("Вы пытаетесь уйти без сохранения!", isPresented: $showBackNavigationAlert) {
            Button("Сохранить и выйти") {
                navigateToEventListWithSave(true)
            }
            Button("Выйти без сохранения") {
                navigateToEventListWithSave(false)
            }
            Button("Остаться", role: .cancel) {
            }
        } message: {
            Text("Без сохранения все изменения будут потеряны")
        }
        .navigationBar(
            model: NavigationBarModel(
                type: .editEvent(title: selectedPage == .spendings ? "Редактирование" : "Информация"),
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
                        placeholder: "Введите название",
                        text: Bindable(viewModel).eventName,
                        type: .largeTitle,
                        isKeyboardShow: $isKeyboardShow
                    )
                }
                .padding(.top, 40)
                .padding(.bottom, 10)

                HStack {
                    Text("Участники")
                        .foregroundStyle(Color.appColor(.textQuaternary))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                    Spacer()
                }

                ForEach(Bindable(viewModel).contributors.indices, id: \.self) { index in
                    ContributorInfoView(
                        placeholder: "Участник \((index) + 1)",
                        isFocused: $isFocused,
                        contributor: bindingForContributor(at: index, in: Bindable(viewModel).contributors),
                        onAction: onAction,
                        isDeleteMode: $isDeleteMode,
                        isKeyboardShow: $isKeyboardShow
                    )
                    .padding(.vertical, 6)
                }
            }
            .padding(.horizontal)
            .foregroundStyle(Color.appColor(.backgroundSecondary))
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
                coordinateSpace: coordinateSpaceName
            )
            .opacity(isAddButtonInListVisible ? 1 : 0)
            .disabled(!isAddButtonInListVisible)
        }
        .onChange(of: isKeyboardShow) { _, isKeyboardVisible in
            keyboardHeight = isKeyboardVisible ? 335 : 0
        }
        .contentMargins(.bottom, keyboardHeight, for: .scrollContent)
    }

    func buttonStack() -> some View {
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
            if viewModel.noContributors {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 200)
                    Text("Пока нет\nни одного участника")
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
                    Text("Участники")
                        .foregroundStyle(Color.appColor(.textQuaternary))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.top, 40)
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
                                Text("Все расходы")
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
                                Text("Собственные средства")
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
                                Text("В долг")
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
                                title: "Получит от",
                                items: contributorTotalInfo.spendings,
                                count: contributorTotalInfo.spendingsCount
                            )
                        }
                        /// Заголовок блока "Должен"
                        if contributorTotalInfo.debts.isNotEmpty {
                            debtSpending(
                                title: "Долг перед",
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
        if withSave {
            viewModel.saveAllChanges()
        }

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
                title: "Сохранено",
                message: "Внесенные изменения сохранены",
            )
        )
    }

    func createInfoToast() -> some View {
        ToastView(
            showToast: $showInfoToast,
            toastData: ToastView.ToastData(
                title: "Нельзя удалить участника",
                message: "В мероприятии должен быть хотя бы один участник"
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
