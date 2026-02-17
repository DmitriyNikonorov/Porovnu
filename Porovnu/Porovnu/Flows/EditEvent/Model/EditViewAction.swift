//
//  EditViewAction.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 17.02.2026.
//

enum EditViewAction {
    case onTap(spending: Spending, contributor: Contributor)
    case onDelete(spending: Spending, contributor: Contributor)
}
