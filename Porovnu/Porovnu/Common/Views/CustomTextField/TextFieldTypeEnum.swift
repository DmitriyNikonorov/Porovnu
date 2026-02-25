//
//  TextFieldTypeEnum.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 21.02.2026.
//

import SwiftUI

struct Frame {
    let size: CGFloat
    let alignment: Alignment

    init(size: CGFloat, alignment: Alignment = .center) {
        self.size = size
        self.alignment = alignment
    }
}

enum TextFieldTypeEnum {
    struct CustomType {
        let foregroundColor: Color
        let backgroundColor: Color
        let textFont: Font
        let horizontalPadding: CGFloat?
        let verticalPadding: CGFloat?
        let keyboardType: UIKeyboardType
        let closeBottonFrame: Frame?
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
            Color.clear

        case let .custom(type):
            type.backgroundColor
        }
    }

    var textFont: Font {
        switch self {
        case .casual, .largeAmount:
                .system(size: 18)

        case .title:
                .system(size: 18.0, weight: .semibold)

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

    var frame: Frame {
        switch self {
        case .casual, .largeAmount:
            Frame(size: 12.0)

        case .title:
            Frame(size: 12.0)

        case .largeTitle:
            Frame(size: 14.0)

        case .amount:
            Frame(size: 10.0)

        case let .custom(type):
            Frame(size: type.closeBottonFrame?.size ?? 12.0)
        }
    }
}
