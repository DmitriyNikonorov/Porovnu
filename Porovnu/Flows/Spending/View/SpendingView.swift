//
//  SpendingView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 15.02.2026.
//

import SwiftUI

struct SpendingView: View {

    // MARK: - Private properties

    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    @FocusState private var isFocused: Bool
    @State private var showSummErrorToast = false
    @State private var showNameErrorToast = false
    @State private var showNoSummErrorToast = false

    private var viewModel: SpendingViewModel

    // MARK: - Init

    init(viewModel: SpendingViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text(viewModel.creditorName)
                    .padding(.top, 16)
                    .padding(.vertical, 20)
                    .foregroundStyle(Color.appColor(.textSecondary))

                Text(Localized.SpendingView.spendingNameLabel)
                    .foregroundStyle(Color.appColor(.textQuaternary))
                CustomTextField(
                    placeholder: Localized.SpendingView.enterNamePlaceholder,
                    position: .single,
                    text: Bindable(viewModel).spendingName
                )

                Text(Localized.SpendingView.totalAmountLabel)
                    .padding(.top, 12)
                    .foregroundStyle(Color.appColor(.textQuaternary))
                AmountConvertTextField(
                    amount: Bindable(viewModel).spendingTotalAmount,
                    placeholder: Localized.SpendingView.enterTotalAmountPlaceholder,
                    type: .largeAmount
                )
// TODO: SU-22 Раскоментить когда будет добавлено описание траты
//                .modifier(ShakeEffect(delta: numberOfShakes))
//                Text("Описание")
//                    .padding(.top, 12)
//                    .foregroundStyle(Color.appColor(.textQuaternary))
//                CustomTextField(
//                    placeholder: "Введите описание",
//                    position: .single,
//                    text: Bindable(viewModel).spendingDiscription
//                )
            }
            .padding(.horizontal)
            .padding(.bottom, 16)

            listView()
                .background(Color.appColor(.backgroundQuaternary))

            HStack {
                Spacer()
                Button {
                    withAnimation {
                        switch viewModel.save() {
                        case .success:
                            navigationCoordinator.navigateBack()

                        case .noSpendingName:
                            showNameErrorToast = true

                        case .notCorrentSumm:
                            showSummErrorToast = true

                        case .noSumm:
                            showNoSummErrorToast = true
                        }
                    }
                } label: {
                    Text(
                        viewModel.spending.isNil
                        ? Localized.SpendingView.addSpending
                        : Localized.SpendingView.saveSpending
                    )
                    .foregroundStyle(Color.appColor(.orangeBrand))
                }
                Spacer()
            }
            .padding(.vertical, 36)
        }
        .onTapGesture {
            isFocused = false
        }
        .showToast(
            showToast: $showSummErrorToast,
            content: createErrorToast(for: .notCorrentSumm)
        )
        .showToast(
            showToast: $showNameErrorToast,
            content: createErrorToast(for: .noSpendingName)
        )
        .showToast(
            showToast: $showNoSummErrorToast,
            content: createErrorToast(for: .noSumm)
        )
        .navigationBar(
            model: NavigationBarModel(
                type: .editSpending(
                    title: viewModel.spending.isNil
                    ? Localized.SpendingView.addSpendingTitle
                    : Localized.SpendingView.editSpendingTitle
                ),
                leadingButtonAction: leadingButtonAction
            )
        )
        .background(Color.appColor(.backgroundSecondary))
    }
}

// MARK: - Private

private extension SpendingView {
    var leadingButtonAction: NavigationBarButtonActionType {
        NavigationBarButtonActionType(
            firstAction: {
                navigationCoordinator.navigateBack()
            }
        )
    }

    @ViewBuilder
    func createErrorToast(for result: SpendingSaveResult) -> some View {
        switch result {
        case .noSpendingName:
            ToastView(
                showToast: $showNameErrorToast,
                toastData: ToastView.ToastData(
                    title: Localized.Common.errorTitle,
                    message: Localized.SpendingView.nameCannotBeEmpty
                )
            )

        case .notCorrentSumm:
            ToastView(
                showToast: $showSummErrorToast,
                toastData: ToastView.ToastData(
                    title: Localized.Common.errorTitle,
                    message: Localized.SpendingView.contributorExpensesExceedTotal
                )
            )
        case .noSumm:
            ToastView(
                showToast: $showNoSummErrorToast,
                toastData: ToastView.ToastData(
                    title: Localized.Common.errorTitle,
                    message: "Общая сумма траты не может быть пуста"
                )
            )

        case .success:
            EmptyView()
        }
    }

    // MARK: - List View

    func listView() -> some View {
        VStack {
            Text(Localized.SpendingView.debtorsSection)
                .font(.system(size: 16))
                .padding(.top, 12)
                .padding(.bottom, 4)
                .padding(.horizontal)
                .foregroundStyle(Color.appColor(.textTertiary))
                .multilineTextAlignment(.center)
            Text(Localized.SpendingView.distributeTotalAmountMessage)
                .font(.system(size: 14))
                .padding(.horizontal)
                .foregroundStyle(Color.appColor(.textTertiary))
                .multilineTextAlignment(.center)

            Divider()

            HStack(alignment: .top) {
                /// Левая колонка
                columnView(
                    title: Localized.Common.contributors,
                    image: AppImages.arrowRight.image,
                    items: Bindable(viewModel).holders,
                    isSelected: false,
                    onTap: { holder in
                        viewModel.selectHolder(holder: holder)
                    },
                    onSelectAll: {
                        withAnimation {
                            viewModel.selectAllHolders()
                        }
                    }
                )

                Divider()
                /// Правая колонка
                columnView(
                    title: Localized.SpendingView.selectedContributorsSection,
                    image: AppImages.checklistChecked.image,
                    items: Bindable(viewModel).selectedHolders,
                    isSelected: true,
                    onTap: { holder in
                        viewModel.unselectHolder(holder: holder)
                    }, onSelectAll: {
                        viewModel.distributeSpendingForAll()
                    }
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }

    // MARK: - Column View

    func columnView(
        title: String,
        image: Image,
        items: Binding<[Holder]>,
        isSelected: Bool,
        onTap: @escaping (Holder) -> Void,
        onSelectAll: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .lineLimit(1)
                    .foregroundStyle(Color.appColor(.textTertiary))
                Spacer()
                image
                    .foregroundColor(.appColor(.turquoiseBrand))
                    .frame(width: 16, height: 16)
                    .onTapGesture {
                        onSelectAll()
                    }
            }
            .padding(.vertical, 6)


            if items.wrappedValue.isEmpty {
                emptyStateView
            } else {
                if isSelected && viewModel.showNotDistributedSumm {
                    Text(viewModel.notDistributedSumm > 0
                         ? Localized.SpendingView.undistributedAmount("\(Double(viewModel.notDistributedSumm) / 100)")
                         : Localized.SpendingView.exceededTotalAmount("\(abs(Double(viewModel.notDistributedSumm) / 100))")
                    )
                    .font(.system(size: 12))
                    .lineLimit(2)
                    .foregroundStyle(Color.appColor(.lightOrangeBrand))
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.3), value: viewModel.notDistributedSumm)
                }
                
                LazyVStack(spacing: 8) {
                    ForEach(items.wrappedValue.indices, id: \.self) { index in
                        HolderListView(
                            holder: bindingForHolder(at: index, in: items),
                            isSelected: isSelected,
                            onTap: onTap
                        )
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isSelected && viewModel.showNotDistributedSumm)
    }

    func bindingForHolder(at index: Int, in items: Binding<[Holder]>) -> Binding<Holder> {
        Binding(
            get: {
                guard index < items.wrappedValue.count else {
                    return Holder(
                        spendingId: UUID(),
                        contributorId: UUID(),
                        contributorName: "",
                        amount: 0,
                        isPayer: false
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

    // MARK: - Empty State View

    var emptyStateView: some View {
        VStack {
            Spacer()
            Text(Localized.SpendingView.noSelectedContributors)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 100)
    }
}
