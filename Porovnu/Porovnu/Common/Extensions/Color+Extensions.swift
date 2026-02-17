//
//  Color+Extensions.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 05.02.2026.
//

import SwiftUI

/// Цветовая схема приложения
enum AppColor {
    /// Цвета для фона
    case background
    case backgroundSecondary
    case backgroundTertiary
    case backgroundQuaternary

    /// Цвета для текста
    case text
    case textSecondary
    case textQuaternary
    case textTertiary

    /// Цвета обводок, элементов управления
    case controls
    case border

    /// Фирменные цвета
    case orangeBrand
    case lightOrangeBrand
    case grayBrand
    case turquoiseBrand
    case blueBrand
}

extension Color {

    static func appColor(_ color: AppColor) -> Color {
        switch color {
        case .background:
            Color("background")

        case .backgroundSecondary:
            Color("background_secondary")

        case .backgroundTertiary:
            Color("background_tertiary")

        case .backgroundQuaternary:
            Color("background_quaternary")

        case .text:
            Color("text")

        case .textSecondary:
            Color("text_secondary")

        case .textQuaternary:
            Color("text_quaternary")

        case .textTertiary:
            Color("text_tertiary")

        case .controls:
            Color("controls")

        case .border:
            Color("border")

        case .orangeBrand:
            Color("orange_brand")

        case .lightOrangeBrand:
            Color("light_orange_brand")

        case .grayBrand:
            Color("gray_brand")

        case .turquoiseBrand:
            Color("turquoise_brand")

        case .blueBrand:
            Color("blue_brand")
        }
    }
}
