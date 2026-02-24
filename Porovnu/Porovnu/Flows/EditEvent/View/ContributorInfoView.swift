//
//  ContributorInfoView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 14.02.2026.
//

import SwiftUI

fileprivate struct ContributorInfoViewHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct ContributorInfoView: View {

    // MARK: - Private propertie

    @State private var textFieldHeight: CGFloat = 44

    // MARK: - Public properties

    let placeholder: String
    @FocusState.Binding var isFocused: Bool
    @Binding var contributor: Contributor
    var onAction: (EditViewAction) -> Void
    @Binding var isDeleteMode: Bool

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(spacing: 0) {
                HStack {
                    CustomTextField(
                        placeholder: placeholder,
                        text: $contributor.name,
                        type: .title
                    )
                    Spacer()
                    Button {
                        onAction(.onCreateSpending(contributor))
                    } label: {
                        Text("Добавить трату")
                            .foregroundStyle(Color.appColor(.orangeBrand))
                            .font(.system(size: 12, weight: .regular))
                    }
                }
                .padding(.bottom, contributor.spendings.isNotEmpty ? 10.0 : 0.0)

                if contributor.spendings.isNotEmpty {
                    spendingVStack()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(minHeight: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appColor(.backgroundTertiary))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.appColor(.orangeBrand).opacity(0.3), lineWidth: 1)
                    )
            )
            if isDeleteMode {
                Button {
                    onAction(.onDeleteContributor(contributor.id))
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                    }
                    .foregroundStyle(Color.appColor(.red))
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Private

private extension ContributorInfoView {
    func spendingVStack() -> some View {
        VStack(alignment: .leading, spacing: 0.0) {
            ForEach(contributor.spendings, id: \.id) { spending in
                Divider()
                    .background(Color.appColor(.grayBrand))
                SpendingRowView(
                    spending: spending,
                    contributor: contributor,
                    onAction: onAction
                )
            }
        }
        .padding(.bottom, 4.0)
    }
}
