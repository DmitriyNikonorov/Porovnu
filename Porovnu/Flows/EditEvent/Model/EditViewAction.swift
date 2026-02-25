//
//  EditViewAction.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 17.02.2026.
//

import Foundation

enum EditViewAction {
    case onEditSpending(spending: Spending, contributor: Contributor)
    case onDeleteSpending(spending: Spending, contributor: Contributor)
    case onCreateSpending(Contributor)
    case onDeleteContributor(UUID)
}
