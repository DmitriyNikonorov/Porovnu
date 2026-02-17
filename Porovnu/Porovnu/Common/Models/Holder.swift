//
//  Holder.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import Foundation
// Доля в трате
struct Holder: Hashable {
    let id: UUID
    /// Родительская трата
    let spendingId: UUID
    /// На кого потратили
    let contributorId: UUID
    /// Размер долго в этой части траты
    let amount: Double
    /// Является ли плательщиком
    let isPayer: Bool
//    let type: HolderType

    init(id: UUID = UUID(), spendingId: UUID, contributorId: UUID, amount: Double, isPayer: Bool) {
        self.id = id
        self.spendingId = spendingId
        self.contributorId = contributorId
        self.amount = amount
        self.isPayer = isPayer
    }
}

enum HolderType {
    case reditor, debtor
}
