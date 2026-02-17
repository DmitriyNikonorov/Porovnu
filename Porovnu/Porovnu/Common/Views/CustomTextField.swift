//
//  CustomTextField.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        TextField("", text: $text)
            .focused($isFocused)
            .placeholder(when: text.isEmpty) {
                Text(placeholder)
                    .foregroundColor(.appColor(.textTertiary)) // цвет плейсхолдера
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(
                Color.appColor(.backgroundQuaternary)
            )
            .foregroundColor(.appColor(.text)) // цвет текста
            .accentColor(.appColor(.orangeBrand)) // цвет курсора
    }
}
