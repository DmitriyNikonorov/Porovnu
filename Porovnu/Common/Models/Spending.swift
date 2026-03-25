//
//  Spending.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import Foundation
// Трата
struct Spending: Hashable, Identifiable {

    let id: UUID
    /// Чья это трата
    let contributorId: UUID
    /// Название траты
    let name: String
    /// Cумма всей траты
    let totalAmount: Double
    /// Должники по трате
    let holders: [Holder]

    init(id: UUID = UUID(), contributorId: UUID, name: String, totalAmount: Double, holders: [Holder]) {
        self.id = id
        self.contributorId = contributorId
        self.name = name
        self.totalAmount = totalAmount
        self.holders = holders
    }

    init(dataBaseModel: SpendingModel) {
        let holders = dataBaseModel.holders.map {
            Holder(
                id: $0.id,
                spendingId: $0.spending?.id ?? UUID(),
                contributorId: $0.contributorId,
                contributorName: $0.contributorName,
                amount: $0.amount,
                isPayer: $0.isPayer
            )
        }
        self.init(
            id: dataBaseModel.id,
            contributorId: dataBaseModel.contributorId,
            name: dataBaseModel.name,
            totalAmount: dataBaseModel.totalAmount,
            holders: holders
        )
    }
}

// MARK: - CustomStringConvertible

extension Spending: CustomStringConvertible {
    var description: String {
        """
        💰 Spending[
          id: \(id.uuidString.prefix(8))...
          contributorId: \(contributorId.uuidString.prefix(8))...
          name: "\(name)"
          total: \(String.amountString(totalAmount))
          holders: \(holders.count)
        ]
        """
    }
}
