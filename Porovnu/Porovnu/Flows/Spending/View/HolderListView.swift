//
//  ContributorListView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 16.02.2026.
//

import SwiftUI

struct HolderListView: View {
    
    let isSelected: Bool
    @FocusState.Binding var isFocused: Bool
    @Binding var holder: Holder
    var onTap: (Holder) -> Void

    // Вычисляемое свойство для преобразования Double <-> String
    // Разобрать
    private var amountBinding: Binding<String> {
        Binding<String>(
            get: {
                // Если amount == 0, возвращаем пустую строку, иначе форматируем
                holder.amount == 0 ? "" : String(format: "%.2f", holder.amount)
            },
            set: { newValue in
                // Пытаемся преобразовать строку в Double
                if let value = Double(newValue.replacingOccurrences(of: ",", with: ".")) {
                    holder.amount = value
                } else if newValue.isEmpty {
                    holder.amount = 0
                }
                // Если не число - игнорируем
            }
        )
    }


    var body: some View {
        HStack {
            if !isSelected {
                Spacer()
            }
            Text(holder.contributorName)
                .onTapGesture {
                    withAnimation {
                        onTap(holder)
                    }
                }
            if isSelected {
                CustomTextField(
                    placeholder: "Сумма",
                    position: .single,
                    text: amountBinding,
                    isFocused: $isFocused,
                    type: .amount
                )
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
            }

            if !isSelected {
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appColor(.backgroundTertiary))
        )
    }
}
