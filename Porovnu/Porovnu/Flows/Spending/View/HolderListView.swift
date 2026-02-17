//
//  HolderListView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 16.02.2026.
//

import SwiftUI

struct HolderListView: View {
    let isSelected: Bool
    @Binding var holder: Holder
    @FocusState var isFocused: Bool
    @State private var displayAmount: String = ""
    var onTap: (Holder) -> Void

    var body: some View {
        HStack {
            if !isSelected {
                Spacer()
            }
            Text(holder.contributorName)
                .foregroundStyle(Color.appColor(.textSecondary))
                .onTapGesture {
                    withAnimation {
                        onTap(holder)
                    }
                }
            if isSelected {
                CustomTextField(
                    placeholder: "Сумма",
                    position: .single,
                    text: $displayAmount,
                    isFocused: $isFocused,
                    type: .amount
                )
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
        .onAppear {
            updateDisplayAmount()
        }
        .onChange(of: holder.amount) { _, _ in
            updateDisplayAmount()
        }

        .onChange(of: holder.amount) { updateDisplayAmount() }
              // ← КЛЮЧЕВОЕ: синхронизация ПРИ КАЖДОМ изменении текста!
              .onChange(of: displayAmount) { _, newValue in
                  applyAmount(newValue)
              }
    }

    private func applyAmount(_ text: String) {
        if text.isEmpty {
            holder.amount = 0
        } else if let value = Double.amountFrom(text) {
            holder.amount = value
        }
        // Игнорируем некорректный ввод — оставляем предыдущее значение
    }

    private func updateDisplayAmount() {
        // ← Изменено: НЕ перезаписываем во время редактирования!
        guard !isFocused else {
            return
        }

        displayAmount = holder.amount == 0 ? "" : String.amountString(amount: holder.amount)
    }
}

