//
//  AmountConvertTextField.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 21.02.2026.
//

import SwiftUI

struct AmountConvertTextField: View {

    // MARK: - Private properties
    @FocusState private var isFocusedState: Bool
    @State private var displayAmount: String = String()

    // MARK: - Public properties

    @Binding var amount: Double
    @State var isFocused = false
    let placeholder: String
    let type: TextFieldTypeEnum
    private var onFocusChange: ((Bool) -> Void)?

    init(
        amount: Binding<Double>,
        placeholder: String = "0",
        type: TextFieldTypeEnum = .casual
    ) {
        self._amount = amount
        self.placeholder = placeholder
        self.type = type
        _isFocused = .init(initialValue: isFocused)

    }

    var body: some View {
        CustomTextField(
            placeholder: placeholder,
            position: .single,
            text: $displayAmount,
            onFocusChange: { newFocus in
                isFocused = newFocus
            },
            type: type
        )
        .onAppear {
            updateDisplayAmount()
        }
        .onChange(of: amount) {
            updateDisplayAmount()
        }
        .onChange(of: displayAmount) { _, newValue in
            applyAmount(newValue)
        }
    }
}

// MARK: - Private

private extension AmountConvertTextField {
    func applyAmount(_ text: String) {
        if text.isEmpty {
            amount = 0
        } else if let value = Double.amountFrom(text) {
            amount = value
        }
    }
    
    func updateDisplayAmount() {
        guard !isFocused else {
            return
        }

        displayAmount = amount == 0 ? "" : String.amountString(amount)
    }
}

