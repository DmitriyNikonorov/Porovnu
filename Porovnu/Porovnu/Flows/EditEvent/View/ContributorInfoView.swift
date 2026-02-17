//
//  ContributorInfoView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 14.02.2026.
//

import SwiftUI

struct ContributorInfoView: View {

    @FocusState.Binding var isFocused: Bool
    @Binding var contributor: Contributor
    var onAction: (EditViewAction) -> Void

    var body: some View {
        VStack {
            HStack {
                CustomTextField(
                    placeholder: "Введите имя",
                    text: $contributor.name,
                    isFocused: $isFocused,
                    type: .title
                )
                Spacer()
                Button {
                    print("add spending")
                } label: {
                    Text("Добавить трату")
                        .foregroundStyle(Color.appColor(.textTertiary))
                        .font(.system(size: 16, weight: .regular))
                }
            }
            .padding(.bottom, contributor.spendings.isNotEmpty ? 10.0 : 0.0)

            if contributor.spendings.isNotEmpty {
                spendingVStack()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appColor(.backgroundTertiary))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appColor(.orangeBrand).opacity(0.3), lineWidth: 1)
                )
        )
    }

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
