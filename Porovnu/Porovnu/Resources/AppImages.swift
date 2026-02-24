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
    case close
    case edit
    case save
    case checklistChecked
    case arrowRight

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

            case .close:
                "xmark"

            case .edit:
                "square.and.pencil"

            case .save:
                "square.and.arrow.down"

            case .checklistChecked:
                "checklist.checked"

            case .arrowRight:
                "arrow.right"
            }
    }

    var image: Image {
        switch self {
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
