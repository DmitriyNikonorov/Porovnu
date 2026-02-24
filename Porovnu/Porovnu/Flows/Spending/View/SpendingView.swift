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

                Text("Название траты:")
                    .foregroundStyle(Color.appColor(.textQuaternary))
                CustomTextField(
                    placeholder: "Введите название",
                    position: .single,
                    text: Bindable(viewModel).spendingName
                )

                Text("Общая суммма траты")
                    .padding(.top, 12)
                    .foregroundStyle(Color.appColor(.textQuaternary))
                AmountConvertTextField(
                    amount: Bindable(viewModel).spendingTotalAmount,
                    placeholder: "Введите общую сумму",
                    type: .largeAmount
                )
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
                        }
                    }
                } label: {
                    Text(viewModel.spending.isNil ? "Добавить трату" : "Сохранить трату")
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
            content: createErrorSummToast()
        )
        .showToast(
            showToast: $showNameErrorToast,
            content: createErrorNameToast()
        )
        .navigationBar(
            model: NavigationBarModel(
                type: .editSpending(
                    title: viewModel.spending.isNil ? "Добавление траты" : "Редактирование траты"
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

    func createErrorSummToast() -> some View {
        ToastView(
            showToast: $showSummErrorToast,
            toastData: ToastView.ToastData(
                title: "Ошибка!",
                message: "Траты участников не могу превышать общую сумму"
            )
        )
    }

    func createErrorNameToast() -> some View {
        ToastView(
            showToast: $showNameErrorToast,
            toastData: ToastView.ToastData(
                title: "Ошибка!",
                message: "Название траты не должно быть пустым"
            )
        )
    }

    // MARK: - List View

    func listView() -> some View {
        VStack {
            Text("Должники по этой трате")
                .padding(.top, 12)
                .padding(.horizontal)
                .foregroundStyle(Color.appColor(.textTertiary))

            Divider()

            HStack(alignment: .top) {
                // Левая колонка
                columnView(
                    title: "Участники",
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
                // Правая колонка
                columnView(
                    title: "Выбранные",
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
            Text("Нет выбранных")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 100)
    }
}

// FIXME: - Доделат в следующей итерации

//struct ShakeEffect: AnimatableModifier {
//    var delta: CGFloat = 0
//    var animatableData: CGFloat {
//        get {
//            delta
//        } set {
//            delta = newValue
//        }
//    }
//
//    func body(content: Content) -> some View {
//        content
//            .rotationEffect(Angle(degrees: sin(delta * .pi * 4.0) * CGFloat.random(in: 2...4)))
//            .offset(x: sin(delta * 1.5 * .pi * 1.2),
//                    y: cos(delta * 1.5 * .pi * 1.1))
//    }
//}


//extension View {
//    func shake(isActive: Bool) -> some View {
//        modifier(ShakeEffect(isShaking: isActive))
//    }
//}
