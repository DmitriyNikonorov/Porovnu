//
//  CustomTextField.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import SwiftUI

struct CustomTextField: View {

    // MARK: - Private properties

    @FocusState private var isFocusedInternal: Bool

    // MARK: - Public properties

    let placeholder: String
    let position: FieldPosition?

    @Binding var text: String
    let onFocusChange: ((Bool) -> Void)?
    let type: TextFieldTypeEnum
    @Binding var isKeyboardShow: Bool

    // MARK: - Init

    init(
        placeholder: String,
        position: FieldPosition? = nil,
        text: Binding<String>,
        onFocusChange: ((Bool) -> Void)? = nil,
        type: TextFieldTypeEnum = .casual,
        isKeyboardShow: Binding<Bool>? = nil
    ) {
        self.placeholder = placeholder
        self.position = position
        self._text = text
        self.onFocusChange = onFocusChange
        self.type = type
        if let binding = isKeyboardShow {
            self._isKeyboardShow = binding
        } else {
            self._isKeyboardShow = .constant(false)
        }
    }

    // MARK: - Body

    var body: some View {
        HStack {
            TextField("", text: trimmedText)
                .focused($isFocusedInternal)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(.appColor(.textQuaternary))
                        .font(type.textFont)
                }
                .submitLabel(.done)
                .onChange(of: isFocusedInternal) { _, isFocused in
                    onFocusChange?(isFocused)
                    isKeyboardShow = isFocused
                }
                .onSubmit {
                    isFocusedInternal = false
                }
                .padding(type.horizontalPadding.edges, type.horizontalPadding.length ?? 0)
                .padding(type.verticalPadding.edges, type.verticalPadding.length ?? 0)
                .foregroundColor(type.foregroundColor)
                .accentColor(.appColor(.orangeBrand))
                .font(type.textFont)
                .keyboardType(type.keyboardType)

            if text.isNotEmpty && isFocusedInternal {
                Button {
                    text = ""
                } label: {
                    AppImages.close.image
                        .resizable()
                        .frame(type.frame)
                        .foregroundStyle(type.foregroundColor)
                }
                .padding(.trailing, 10)
            }
        }
        .background(type.backgroundColor)
        .clipShape(
            createRectangle(for: position)
        )
    }
}

// MARK: - Private

private extension CustomTextField {
    var trimmedText: Binding<String> {
        Binding(
            get: {
                text.isNotEmpty ? text : ""
            },
            set: { newValue in
                text = newValue.trim()
            }
        )
    }

    func createRectangle(for position: FieldPosition?) -> UnevenRoundedRectangle {
        let radius: CGFloat = 10
        switch position {
        case .single:
            return .init(corners: .all(radius))

        case .top:
            return .init(corners: .top(radius))

        case .middle:
            return .init(corners: .all(.zero))

        case .bottom:
            return .init(corners: .bottom(radius))

        case .none:
            return .init(corners: .all(.zero))
        }
    }
}
