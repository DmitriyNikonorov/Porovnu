//
//  Holder.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import Foundation
// Доля в трате
struct Holder: Hashable, Identifiable {
    let id: UUID
    /// Родительская трата
    let spendingId: UUID
    /// На кого потратили
    let contributorId: UUID
    /// Имя на кого потратили
     let contributorName: String
    /// Размер долго в этой части траты
    var amount: Double
    /// Является ли плательщиком
    let isPayer: Bool
//    let type: HolderType

    init(id: UUID = UUID(), spendingId: UUID, contributorId: UUID, contributorName: String, amount: Double, isPayer: Bool) {
        self.id = id
        self.spendingId = spendingId
        self.contributorId = contributorId
        self.contributorName = contributorName
        self.amount = amount
        self.isPayer = isPayer
    }

    init(dataBaseModel: HolderModel) {
        self.init(
            id: dataBaseModel.id,
            spendingId: dataBaseModel.spendingId,
            contributorId: dataBaseModel.contributorId,
            contributorName: dataBaseModel.contributorName,
            amount: dataBaseModel.amount,
            isPayer: dataBaseModel.isPayer
        )
    }

    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }

       static func == (lhs: Holder, rhs: Holder) -> Bool {
           lhs.id == rhs.id
       }
}

enum HolderType {
    case reditor, debtor
}
