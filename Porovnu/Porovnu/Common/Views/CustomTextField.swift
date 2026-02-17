//
//  CustomTextField.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import SwiftUI

enum TextFieldTypeEnum {
    struct CustomType {
        let foregroundColor: Color
        let backgroundColor: Color
        let textFont: Font
        let horizontalPadding: CGFloat?
        let verticalPadding: CGFloat?
        let keyboardType: UIKeyboardType
    }

    case casual, title, largeTitle, amount, largeAmount, custom(CustomType)

    var foregroundColor: Color {
        switch self {
        case .casual, .largeAmount:
                .appColor(.textSecondary)

        case .title:
                .appColor(.textSecondary)

        case .largeTitle:
                .appColor(.orangeBrand)

        case .amount:
                .appColor(.textSecondary)

        case let .custom(type):
            type.foregroundColor
        }
    }

    var backgroundColor: Color {
        switch self {
        case .casual, .largeAmount:
                .appColor(.backgroundQuaternary)

        case .title, .largeTitle:
                .clear

        case .amount:
                .appColor(.backgroundQuaternary)

        case let .custom(type):
            type.backgroundColor
        }
    }

    var textFont: Font {
        switch self {
        case .casual, .largeAmount:
                .system(size: 18)

        case .title:
                .system(size: 20.0, weight: .semibold)

        case .largeTitle:
                .system(size: 24, weight: .bold)

        case .amount:
                .system(size: 16)

        case let .custom(type):
            type.textFont
        }
    }

    var horizontalPadding: (edges: Edge.Set, length: CGFloat?) {
        switch self {
        case .casual, .largeTitle, .largeAmount:
            (.horizontal, 12)

        case .title:
            (.horizontal, .zero)

//        case .largeTitle:
//            (.horizontal, 12)

        case .amount:
            (.horizontal, 4)

        case .custom(let customType):
            (.horizontal, customType.horizontalPadding)
        }
    }

    var verticalPadding: (edges: Edge.Set, length: CGFloat?) {
        switch self {
        case .casual, .largeAmount:
            (.vertical, 14)

        case .title:
            (.vertical, .zero)

        case .largeTitle:
            (.vertical, .zero)

        case .amount:
            (.vertical, 4)

        case .custom(let customType):
            (.vertical, customType.verticalPadding)
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
        case .casual, .title, .largeTitle:
                .default

        case .amount, .largeAmount:
                .decimalPad

        case .custom(let customType):
            customType.keyboardType
        }
    }
}

struct CustomTextField: View {

    let placeholder: String
    let position: FieldPosition?

    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    let type: TextFieldTypeEnum

    init(
        placeholder: String,
        position: FieldPosition? = nil,
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        type: TextFieldTypeEnum = .casual
    ) {
        self.placeholder = placeholder
        self.position = position
        self._text = text
        self._isFocused = isFocused
        self.type = type
    }

    var body: some View {
        TextField("", text: $text)
            .focused($isFocused)
            .placeholder(when: text.isEmpty) {
                Text(placeholder)
                    .foregroundColor(.appColor(.textTertiary)) // цвет плейсхолдера
                    .font(type.textFont)
            }
            .padding(type.horizontalPadding.edges, type.horizontalPadding.length)
            .padding(type.verticalPadding.edges, type.verticalPadding.length)
            .background(type.backgroundColor)
            .foregroundColor(type.foregroundColor) // цвет текста
            .accentColor(.appColor(.orangeBrand)) // цвет курсора
            .clipShape(
                createRectangle(for: position)
            )
            .font(type.textFont)
            .keyboardType(type.keyboardType)
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

enum Corners {
    case top(CGFloat), bottom(CGFloat), leading(CGFloat), trailing(CGFloat), all(CGFloat)
}


extension UnevenRoundedRectangle {

    init(corners: Corners) {
        switch corners {
            case .top(let value):
            self.init(cornerRadii: RectangleCornerRadii(topLeading: value, bottomLeading: .zero, bottomTrailing: .zero, topTrailing: value))

        case .bottom(let value):
            self.init(cornerRadii: RectangleCornerRadii(topLeading: .zero, bottomLeading: value, bottomTrailing: value, topTrailing: .zero))

        case .leading(let value):
            self.init(cornerRadii: RectangleCornerRadii(topLeading: value, bottomLeading: value, bottomTrailing: .zero, topTrailing: .zero))

        case .trailing(let value):
            self.init(cornerRadii: RectangleCornerRadii(topLeading: .zero, bottomLeading: .zero, bottomTrailing: value, topTrailing: value))

        case .all(let value):
            self.init(cornerRadii: RectangleCornerRadii(topLeading: value, bottomLeading: value, bottomTrailing: value, topTrailing: value))
        }

    }
}
