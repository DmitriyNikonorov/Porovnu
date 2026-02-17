//
//  AppImages.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import SwiftUI

enum AppImages {
    case person2Fill
    case personBadgePlus
    case homeTab
    case profileTab
    case editPencil
    case listClipboard
    case trash

    var sring: String {
            switch self {
            case .person2Fill:
                "person.2.fill"

            case .personBadgePlus:
                "person.badge.plus"

            case .homeTab:
                "house"

            case .profileTab:
                "person"

            case .editPencil:
                "square.and.pencil"

            case .listClipboard:
                "list.bullet.clipboard"

            case .trash:
                "trash"
            }
    }

    var image: Image {
        switch self {
//        case .person2Fill, .personBadgePlus, .homeTab, .profileTab, .editPencil, .listClipboard, .trash:
        default:
            Image(systemName: sring)
        }
    }

    var tabBarImageName: String {
        switch self {
        case .homeTab:
            "house"

        case .profileTab:
            "person"

        default:
            String()
        }
    }
}
