//
//  Spending.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import Foundation
// Трата
struct Spending: Hashable {
    let id: UUID
    /// Чья это трата
    let contributorId: UUID
    let totalAmount: Double // (сумма всей траты)
    /// Должники по трате
    let holders: [Holder]

    init(id: UUID = UUID(), contributorId: UUID, totalAmount: Double, holders: [Holder]) {
        self.id = id
        self.contributorId = contributorId
        self.totalAmount = totalAmount
        self.holders = holders
    }
//    let transactionType: TransactionType

    // НЕ ОЧЕНЬ АКТУАЛЬНО УЖЕ - Удобно получаение в виде словаря
//    var debtorsForThisSpending: [UUID: Double] {
//        //(должники по трате id участника и сумма долга)
//        get{             return holders.reduce(into: [:]) { result, debt in 
//            result[debt.id] = debt.summ 
//        } 
//        } 
//    }

    init(dataBaseModel: SpendingModel) {
        let holders = dataBaseModel.holders.map {
            Holder(
                id: $0.id,
                spendingId: $0.spending!.id,
                contributorId: dataBaseModel.contributorId,
                amount: $0.amount,
                isPayer: $0.isPayer
            )
        }
        self.init(
            id: dataBaseModel.id,
            contributorId: dataBaseModel.contributorId,
            totalAmount: dataBaseModel.totalAmount,
            holders: holders
        )
    }
}
