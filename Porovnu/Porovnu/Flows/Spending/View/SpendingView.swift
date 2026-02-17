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
                    .padding(.top, 26)
                    .padding(.vertical, 20)
                    .foregroundStyle(Color.appColor(.textSecondary))

                Text("Название траты:")
                    .foregroundStyle(Color.appColor(.textQuaternary))
                CustomTextField(
                    placeholder: "Введите название",
                    position: .single,
                    text: Bindable(viewModel).spendingName,
                    isFocused: $isFocused,
                )

                Text("Стоимость")
                    .padding(.top, 12)
                    .foregroundStyle(Color.appColor(.textQuaternary))
                CustomTextField(
                    placeholder: "Введите стоимость",
                    position: .single,
                    text: Bindable(viewModel).spendingTotalAmount,
                    isFocused: $isFocused,
                    type: .largeAmount
                )

                Text("Описание")
                    .padding(.top, 12)
                    .foregroundStyle(Color.appColor(.textQuaternary))
                CustomTextField(
                    placeholder: "Введите описание",
                    position: .single,
                    text: Bindable(viewModel).spendingDiscription,
                    isFocused: $isFocused
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
            listView()
            .background(Color.appColor(.backgroundQuaternary))

            HStack {
                Spacer()
                Button(viewModel.spending.isNil ? "Добавить трату" : "Сохранить трату") {
                    viewModel.save(completion: navigationCoordinator.navigateBack)
                }
                Spacer()
            }
            .padding(.top, 20)
        }
        .onTapGesture {
            isFocused = false
        }
        .background(Color.appColor(.backgroundSecondary))
    }
}

// MARK: - Private

private extension SpendingView {

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
                    items: Bindable(viewModel).holders,
                    isSelected: false,
                    onTap: { holder in
                        viewModel.deleteLeft(holder: holder)
                    }
                )

                Divider()
                // Правая колонка
                columnView(
                    title: "Выбранные",
                    items: Bindable(viewModel).selectedHolders,
                    isSelected: true,
                    onTap: { holder in
                        viewModel.deleteRight(holder: holder)
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
        items: Binding<[Holder]>,
        isSelected: Bool,
        onTap: @escaping (Holder) -> Void
    ) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(Color.appColor(.textTertiary))
                .padding(.vertical, 6)

            if items.wrappedValue.isEmpty {
                emptyStateView
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(items.wrappedValue.indices, id: \.self) { index in
                        HolderListView(
                            isSelected: isSelected,
                            holder: bindingForHolder(at: index, in: items),
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
