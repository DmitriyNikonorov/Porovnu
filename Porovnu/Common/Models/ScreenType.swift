//
//  ScreenType.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 04.02.2026.
//

import SwiftUI

enum ScreenType {
    case home(title: String)
    case creationEvent(title: String)
    case event(title: String)
    case editEvent(title: String)
    case editSpending(title: String)
}
