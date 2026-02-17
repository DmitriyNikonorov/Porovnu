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

    var image: Image {
        switch self {
        case .person2Fill:
            Image(systemName: "person.2.fill")
            
        case .personBadgePlus:
            Image(systemName: "person.badge.plus")

        case .homeTab:
            Image(systemName: "house")

        case .profileTab:
            Image(systemName: "person")
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
