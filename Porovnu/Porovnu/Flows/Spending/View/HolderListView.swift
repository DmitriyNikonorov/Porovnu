//
//  HolderListView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 16.02.2026.
//

import SwiftUI

struct HolderListView: View {

    // MARK: - Public propertie

    @Binding var holder: Holder
    @FocusState var isFocused: Bool
    let isSelected: Bool
    var onTap: (Holder) -> Void

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appColor(.backgroundTertiary))
                .overlay(
                    isSelected
                    ? RoundedRectangle(cornerRadius: 16).stroke(Color.appColor(.orangeBrand).opacity(0.3), lineWidth: 1)
                    : nil
                )
            HStack(spacing: 0) {
                if !isSelected {
                    Spacer()
                }

                Text(holder.contributorName)
                    .foregroundStyle(Color.appColor(.textSecondary))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.vertical, 10)
                    .padding(.leading, 8)
                    .padding(.trailing, 8)
                    .layoutPriority(1)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            onTap(holder)
                        }
                    }
                if isSelected {
                    Divider()
                        .background(Color.appColor(.orangeBrand))
                    AmountConvertTextField(
                        amount: $holder.amount,
                        placeholder: "Сумма",
                        type: .amount
                    )
                    .layoutPriority(1)
                }
                if !isSelected {
                    Spacer()
                }
            }
        }
    }
}
