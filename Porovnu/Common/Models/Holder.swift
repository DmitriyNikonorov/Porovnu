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
    /// Размер долга в этой части траты
    var amount: Int
    /// Является ли плательщиком
    let isPayer: Bool

    init(id: UUID = UUID(), spendingId: UUID, contributorId: UUID, contributorName: String, amount: Int, isPayer: Bool) {
        self.id = id
        self.spendingId = spendingId
        self.contributorId = contributorId
        self.contributorName = contributorName
        self.amount = amount
        self.isPayer = isPayer
    }

    init(holder: Holder, amount: Int) {
        self.init(
            id: holder.id,
            spendingId: holder.spendingId,
            contributorId: holder.contributorId,
            contributorName: holder.contributorName,
            amount: amount,
            isPayer: holder.isPayer
        )
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
}

enum HolderType {
    case reditor, debtor
}


// MARK: - CustomStringConvertible

extension Holder: CustomStringConvertible {
    var description: String {
        """
        💰 Holder[
          id: \(id.uuidString.prefix(8))...
          spendingId: UUID
          spendingId: \(spendingId .uuidString.prefix(8))...
          contributorId: \(contributorId.uuidString.prefix(8))...
          contributorName: "\(contributorName)"
          amount: \(String.amountString(amount))
          isPayer: \(isPayer)
        ]
        """
    }
}
